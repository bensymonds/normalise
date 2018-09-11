require_relative 'media'
require_relative 'video_attributer'

class Video < Media
  EXTS = %w(.mov .mp4 .3gp)

  def initialize(filename)
    @filename = filename
    fail "Unknown extension: #{ext}" unless EXTS.include?(ext.downcase)
  end

  def exif
    @exif ||= begin
      MiniExiftool.new(filename)
    end
  end

  def attribution
    @attribution ||= VideoAttributer.new(self).attribute
  end

  private

  def exif_ts
    exif.create_date
  end
end
