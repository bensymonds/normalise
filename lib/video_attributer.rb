class VideoAttributer
  attr_reader :video

  def initialize(video)
    @video = video
    @config = JSON.parse(File.read(ENV.fetch("VIDEO_ATTRIBUTIONS_CONFIG_FILE")))
  end

  def attribute
    hits = @config.select do |c|
      value = video.exif.send(c["key"])
      value && value.include?(c["value"])
    end

    fail "Ambiguous" if hits.count > 1

    h = hits.first
    [h["value"], h["then"]] if h
  end
end
