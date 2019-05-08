require_relative 'filename'

class Media
  include Filename

  attr_accessor :additional_index

  PADDINGS = {
    filename: 32,
    best_filename: 30,
    index: 5,
    attr: 11,
    sus: 8,
    source: 11,
    filename_ts: 16,
    exif_ts: 16,
    make_model: 20,
  }

  def inspect
    "#<#{self.class.name}:#{filename}>"
  end

  def best_filename
    [
      format_time(best_ts),
      (additional_index ? format("_%02d", additional_index) : ""),
      (" [#{attribution[1]}]" if attribution),
      (" #{title}" if title),
      ext.downcase,
    ].join if best_ts
  end

  def output
    [
      filename.ljust(PADDINGS[:filename]),
      best_filename.ljust(PADDINGS[:best_filename]),
      (additional_index ? format("%02d", additional_index) : "").ljust(PADDINGS[:index]),
      (attribution && attribution[1] || "").ljust(PADDINGS[:attr]),
      suspiciousness.to_s.ljust(PADDINGS[:sus]),
      (needs_rename? ? best_ts_name.to_s : "[unchanged]").ljust(PADDINGS[:source]),
      (filename_ts ? format_time(filename_ts) : "").ljust(PADDINGS[:filename_ts]),
      (exif && exif_ts ? format_time(exif_ts) : "n/a").ljust(PADDINGS[:exif_ts]),
      (attribution && attribution[0] || "").ljust(PADDINGS[:make_model]),
    ].join("\t")
  end

  def rename!
    return false unless needs_rename?

    fail best_filename if File.exist?(best_filename)

    File.rename(filename, best_filename)
  end

  def needs_rename?
    best_filename != filename
  end

  TS_PRIORITY = [
    :filename_ts,
    :exif_ts,
  ]

  def best_ts
    send(best_ts_name)
  end

  def best_ts_name
    TS_PRIORITY.detect do |ts|
      send(ts)
    end || raise(filename)
  end

  def suspiciousness
    return "?" unless filename_ts && exif_ts
    diff = (filename_ts - exif_ts).abs.to_i
    diff > 10 ? diff : nil
  end

  private

  def format_time(ts)
    case ts
    when Time
      ts.strftime("%Y%m%d_%H%M%S")
    when Date
      ts.strftime("%Y%m%d")
    end
  end
end
