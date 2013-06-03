#!/usr/bin/env ruby


#converts URLs for PKs templates
#
puts ARGV.length
unless ARGV.length == 2
  puts "Come on, you need to specify a filename and the url to redirect to."
  puts "Example: #{$0} beta amazingly_awesome_template.html"

  puts "\n\n"
  puts "So basically we're looking for two things:\n  'stg' or 'beta'\n  a filename"
  puts "Another example: #{$0} stg emu8.html"
  exit 1
end

url_chooser = ARGV[0]
case url_chooser.downcase
when 'stg'
  url = 'https://stg.verticalresponse'
when 'beta'
  url = 'https://beta.skadeedle'
else
  puts "Woah there, I've heard of beta and stg, but what in the sam hill do you mean by '#{url_chooser}'?"
  exit 2
end

file_name = ARGV[1]
puts "OK, I'll use #{file_name}"

# read the file and output
writing_file = file_name.gsub(/\.htm/, "#{url_chooser}.htm")

puts "reading #{file_name}"

unless File.exists? file_name
  puts "Wait.... what #{file_name}??!"
  exit 3
end
input_src = IO.read file_name

input_src.gsub!(/http(s?):\/\/(stg\.verticalresponse|beta\.skadeedle)/, url)


puts "outputting to #{writing_file}"
fin = File.open(writing_file, 'w')
fin.write(input_src)
fin.close

