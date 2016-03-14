require 'date'

module Filename
  attr_reader :filename

  WHATSAPP = /
    ^
    (?<year>\d\d\d\d)
    (?<month>\d\d)
    (?<day>\d\d)
    (_\d\d)?
    \.
    jpg
  /xi

  OUTPUT = /
  ^
  (?<year>\d\d\d\d)
  (?<month>\d\d)
  (?<day>\d\d)
  _
  (?<hour>\d\d)
  (?<minute>\d\d)
  (?<second>\d\d)
  (_\d\d)?
  \ 
  \[
  [\w' ]+?
  \]
  (\ (?<title>.+))?
  \.
  (jpg|mp4|mov)
  $
  /xi

  RES = [
    WHATSAPP,
    OUTPUT,
    /
      (IMG_|VID_|SavedImage_)?
      (?<year>\d\d\d\d)
      (?<month>\d\d)
      (?<day>\d\d)
      _?
      (?<hour>\d\d)?
      (?<minute>\d\d)?
      (?<second>\d\d)?
      (?<ms>\d\d\d)?
      (_Burst\d\d)?
      (_HDR)?
      (_Pano)?
      (_\d\d)?
      (\s\[[A-Z]+\])?
      \.
      (jpg|mp4|mov)
    /xi,
    /
      (Photo|Video)\s
      (?<day>\d\d)-
      (?<month>\d\d)-
      (?<year>\d\d\d\d)\s
      (?<hour>\d\d)\s
      (?<minute>\d\d)\s
      (?<second>\d\d)
      (?<ms>\d\d\d)?
      \.
      (jpg|mov)
    /xi,
    /
      (?<year>\d\d\d\d)-
      (?<month>\d\d)-
      (?<day>\d\d)\s
      (?<hour>\d\d)\.
      (?<minute>\d\d)\.
      (?<second>\d\d)
      (?<ms>\d\d\d)?
      \.
      jpg
    /xi,
    /
      IMG-
      (?<year>\d\d\d\d)
      (?<month>\d\d)
      (?<day>\d\d)
      -
      WA\d\d\d\d
      \.
      jpg
    /xi,
  ]

  def ext
    @ext ||= File.extname(filename).downcase
  end

  def match
    (@match ||= begin
      m = nil
      RES.detect do |re|
        m = re.match(filename)
      end
      [m]
    end).first
  end

  def filename_ts
    return nil unless match

    if match.names.include?('hour')
      Time.new(
        match[:year],
        match[:month],
        match[:day],
        match[:hour],
        match[:minute],
        match[:second],
      )
    else
      Date.new(
        match[:year].to_i,
        match[:month].to_i,
        match[:day].to_i,
      )
    end
  end
end
