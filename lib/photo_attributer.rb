class PhotoAttributer
  attr_reader :photo

  def initialize(photo)
    @photo = photo
    @config = JSON.parse(File.read(ENV.fetch("PHOTO_ATTRIBUTIONS_CONFIG_FILE")))
  end

  def attribute
    hits = @config.select do |model, who|
      photo.exif.model == model
    end

    fail "Ambiguous" if hits.count > 1

    hits.first
  end
end
