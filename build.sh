#!/usr/bin/env bash
cat index.txt | rb 'require "shellwords"; each_with_index{|e,i| e.strip!; `curl #{Shellwords.shellescape(e)} -o #{Shellwords.shellescape("#{i}_#{File.basename(e)}")}` }'
# @see https://en.wikipedia.org/wiki/Comic_book_archive
mkdir -p drugsandwires.fail
cat index.txt | rb 'require "shellwords"; each_with_index { |e, i| e.strip!; `ln -f #{Shellwords.shellescape("#{i}_#{File.basename(e)}")} drugsandwires.fail/#{i.to_s.rjust(4, "0")}#{File.extname(e)}` }'
zip -r drugsandwires.fail.cbz drugsandwires.fail
