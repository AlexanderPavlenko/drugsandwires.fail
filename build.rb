#!/usr/bin/env ruby

require 'shellwords'

system %(rm -rf drugsandwires.fail.cbz drugsandwires.fail; mkdir drugsandwires.fail)

# https://www.drugsandwires.fail/contents/
# on each chapter's page:
# copy($x('//article/div[1]/div/a/img/@src').map(a => a.value).join("\n"))

File.open('index.txt') do |f|
  f.each_line.map(&:strip).reject { |url| url.empty? }.each_with_index do |url, i|
    filename = "#{i}_#{File.basename(url)}"
    filename_cli = Shellwords.shellescape(filename)
    format = File.extname(filename)
    puts filename
    unless File.exists?(filename)
      system %(curl #{Shellwords.shellescape(url)} --retry 5 -o #{filename_cli})
    end
    system %(ln -f #{filename_cli} drugsandwires.fail/#{i.to_s.rjust(4, '0')}#{format})
    if format.downcase == '.gif'
      filename_preview = "#{filename_cli[0..-4]}jpg"
      unless File.exists?(filename_preview)
        system %(ffmpeg -i #{filename_cli} -i gif-mark.png -filter_complex "overlay=0:0" -frames:v 1 -qscale:v 3 -y #{filename_preview})
      end
      system %(ln -f #{filename_preview} drugsandwires.fail/#{i.to_s.rjust(4, '0')}.jpg)
    end
  end
end

system %(zip -r drugsandwires.fail.cbz drugsandwires.fail)