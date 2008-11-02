require 'getoptlong'
require 'open-uri' 
require 'rubygems' 
require 'hpricot' 

version = "0.0.1"

def print_usage(error_code)
  print "TwelveSecondsDownloader -- Download a flv from 12seconds.tv \n"
  print "Usage: ruby TwelveSecondsDownloader.rb [POSIX or GNU options] 12seconds.tv-URL ...\n\n"
  print "POSIX options                     GNU long options\n"
  print "    -f /Users/tom/Downloads           --folder /Users/tom/Downloads \n"
  print "    -t flv or mp4                     --type flv or mp4 \n"
  print "    -h                                --help\n"
  print "    -u                                --usage\n"
  print "    -v                                --version\n\n"
  print "Default: Will download a .flv to current working directory."
  
  print "Examples: \n"
  print "ruby TwelveSecondsDownloader.rb  http://12seconds.tv/channel/identifyus/6761\n"
  print "ruby TwelveSecondsDownloader.rb -f /Users/tom/Downloads http://12seconds.tv/channel/identifyus/6761\n"
  print "ruby TwelveSecondsDownloader.rb --folder /Users/tom/Downloads  http://12seconds.tv/channel/identifyus/6761\n"
  print "\n"
  print "Send bugs to ts@1821design.com\n"
  print "MIT License\n\n"
  exit(error_code)
end

options = GetoptLong.new(   
  [ '--folder', '-f', GetoptLong::OPTIONAL_ARGUMENT ],
  [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
  [ '--usage', '-u', GetoptLong::NO_ARGUMENT ],
  [ '--version', '-v',   GetoptLong::NO_ARGUMENT ]
)

video_url = nil
download_file_type = '.flv'
download_folder = Dir.getwd

options.each do |option, argument|
  case option
    when "--version"
      print "TwelveSecondsDownloader, version ", version, "\n"
      exit(0)
    when "--help"
      print_usage(0)
    when "--usage"
      print_usage(0)
    when '--folder'
      download_folder = argument
  end
end

if ARGV.length != 1
  print_usage(0)
  exit(0)
end

video_url = ARGV.shift

api_xml_address = "http://api.12seconds.tv/video/get/" << video_url.split('/').last << ".xml"
source_xml = open(api_xml_address)  	# => #<StringIO:0xb7bb601c>

Hpricot(source_xml).search("flv_path") do |flv| 
  full_url = flv.inner_html
  file_name = File.basename(full_url)
  file_extention = File.extname(full_url)
  final_destination = File.join(download_folder, file_name)
  open(final_destination,"wb").write(open(full_url).read)
end



