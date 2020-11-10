#!/usr/bin/env ruby

require 'shellwords'

system %(rm -rf drugsandwires.fail.cbz drugsandwires.fail; mkdir drugsandwires.fail)

# https://www.drugsandwires.fail/contents/
# on each chapter's page:
# copy($x('//article/div[1]/div/a/img/@src').map(a => a.value).join("\n"))

File.open('index.txt') do |f|
  f.each_line.map(&:strip).reject { |url| url.empty? }.each_with_index do |url, i|
    filename = "#{i}_#{File.basename(url)}"
    puts filename
    unless File.exists?(filename)
      puts "downloading #{filename}"
      system %(curl #{Shellwords.shellescape(url)} --retry 5 -o #{Shellwords.shellescape(filename)})
    end
    system %(ln -f #{Shellwords.shellescape(filename)} drugsandwires.fail/#{i.to_s.rjust(4, '0')}#{File.extname(filename)})
  end
end

system %(zip -r drugsandwires.fail.cbz drugsandwires.fail)