require 'mini_exiftool'
require_relative 'media'
require_relative 'photo_attributer'

class Photo < Media
  EXTS = %w(.jpg .jpeg)

  private

  def exif_ts
    exif.create_date || exif.date_time_original
  end

  def attribution
    @attribution ||= PhotoAttributer.new(self).attribute
  end
end
