require_relative 'media'
require_relative 'video_attributer'

class Video < Media
  EXTS = %w(.mov .mp4 .3gp .avi)

  def attribution
    @attribution ||= VideoAttributer.new(self).attribute
  end

  private

  def exif_ts
    exif.creation_date || exif.create_date
  end
end
