require 'optparse'
require 'byebug'
require 'dotenv'
Dotenv.load(File.join(__dir__, ".env"))
require_relative 'lib/media_collection'

options = {
  glob: "*",
}
OptionParser.new do |opts|
  opts.on("-o") do |v|
    options[:output] = v
  end
  opts.on("-r") do |v|
    options[:rename] = v
  end
  opts.on("-g", "--glob [GLOB]") do |v|
    options[:glob] = v
  end
end.parse!

case
when options[:output]
  MediaCollection.new(options[:glob]).output
when options[:rename]
  MediaCollection.new(options[:glob]).rename!
end
