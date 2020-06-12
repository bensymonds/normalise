require_relative 'photo'
require_relative 'video'

class MediaCollection
  TYPES = [
    Photo,
    Video,
  ]

  def initialize(glob)
    @media = Dir.glob(glob).map do |fn|
      next if File.directory?(fn)
      next unless TYPES.flat_map { |t| t::EXTS }.include?(File.extname(fn).downcase)
      m = nil
      TYPES.detect do |t|
        begin
          m = t.new(fn)
        rescue
          nil
        end
      end
      m || fail(fn)
    end.compact
    validate
    disambiguate
  end

  def output
    puts %w(
      filename
      best_filename
      index
      attr
      sus
      source
      filename_ts
      exif_ts
      make_model
    ).map { |f| f.ljust(Media::PADDINGS[f.to_sym]) }.join("\t")
    @media.sort_by(&:best_filename).each { |f| puts f.output }
  end

  def rename!
    puts "Total media: #{@media.count}"
    renamed = @media.select(&:rename!)
    puts "Renamed: #{renamed.count}"
  end

  private

  def validate
    @media.each do |m|
      begin
        m.best_filename
      rescue StandardError
        puts m.filename
        raise
      end
    end
  end

  def disambiguate
    @media.group_by(&:best_filename).values.select do |g|
      g.count > 1
    end.each do |g|
      g.sort_by(&:filename).each_with_index do |p, i|
        p.additional_index = i
      end
    end
  end
end
