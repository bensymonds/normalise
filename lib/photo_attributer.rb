class PhotoAttributer
  attr_reader :photo

  def initialize(photo)
    @photo = photo
    @config = JSON.parse(File.read(File.join(File.dirname(__FILE__), "../config/photo_attributions.json")))
  end

  def attribute
    hits = @config.select do |model, who|
      photo.exif.model == model
    end

    fail "Ambiguous" if hits.count > 1

    hits.first
  end
end
