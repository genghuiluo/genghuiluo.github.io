#!/usr/local/bin/ruby

################################################################
#   Copyright (C) 2017 All rights reserved.
#   
#   Filename：wrapper.rb
#   Creator：Mark Luo
#   Created Date：02/28/2017
#   Description： wrapper for regular operations on Jekyll
#               
#   Modified History：
#
################################################################

require 'shellwords'
require 'fileutils'
require 'date'

# usage
def usage
    puts <<-EOF
#{$0} <options> <parameters>

e.g.
#1 create new post:
#{$0} -n/--new-post <title>

#2 commit & push updates:
#{$0} -u/--update

#3 debug @localhost:
#{$0} -d/--debug

#4 list recent n\'s posts
#{$0} -5 # recent five posts

#5 search with keyword
#{$0} -s/--search <keyword>

#6 edit, work with list/search 
#{$0} -e/--edit <seq_in_list/search_output>

#7 hygiene timestamp of posts
#{$0} -h/--hygiene-timestamp
    EOF
end

def new_post
    puts "post title:"
    title = $stdin.gets.chomp

    puts "categories:"
    categories = $stdin.gets.chomp
    
    File.open("./_posts/#{Time.now.strftime("%Y-%m-%d")}-#{title}.md","w") do |f|
        f.puts "---"
        f.puts "layout: post"
        f.puts "title: #{title}"
        f.puts "date: #{Time.now.strftime("%Y-%m-%d %H:%M:%S %z")}"
        f.puts "categories: #{categories}"
        f.puts "---"
    end

    system "vim %s" %  Shellwords.escape("./_posts/#{Time.now.strftime("%Y-%m-%d")}-#{title}.md")
end

# commit & push updates
def update
    system "git add --all && git commit -m '#{Time.now.strftime("auto commit @ %Y-%m-%d %H:%M")}' && git push origin master"
end

def debug
    begin
        system "bundle exec jekyll serve"
    rescue SystemExit, Interrupt
        exit
    end
end

def recent(num)
    File.open(".cache/posts.cache","w") do |f|
        Dir.glob("./_posts/*").sort_by{|p| File.mtime(p)}.reverse.first(num).each_with_index do |p,i|
            f.puts "#{i.to_s}\t#{p}" 
            puts "#{i.to_s}\t#{p}\t#{File.mtime(p)}"
        end
    end
end

def search(key)
    File.open(".cache/posts.cache","w") do |f|
        Dir.glob("./_posts/*#{key}*",File::FNM_CASEFOLD).sort_by{|p| File.mtime(p)}.reverse.each_with_index do |p,i|
            f.puts "#{i.to_s}\t#{p}" 
            puts "#{i.to_s}\t#{p}\t#{File.mtime(p)}"
        end
    end
end

def edit(seq)
    File.open(".cache/posts.cache","r").each_line do |l|
        l_arr = l.strip.split("\t")
        if l_arr[0] == seq
            system "vim %s" %  Shellwords.escape(l_arr[1])
            exit
        end
    end
    puts "Error: No such sequence ID!"
end

def hygiene_timestamp
    Dir.glob("./_posts/*").each do |p|
        File.open(p, "r").each_line do |l|
           if match = l.match(/date:\ (\d{4}\-\d{2}\-\d{2})\ (\d{2}\:\d{2}\:\d{2})(.*)/)
              date, time, zone = match.captures
              filename_pre,filename_tail = p.match(/(.*)\d{4}\-\d{2}\-\d{2}(.*)/).captures
              #puts "#{filename_pre}#{date}#{filename_tail}"
              #puts "#{date} #{time}#{zone}"
              datetime = DateTime.parse("#{date} #{time}#{zone}")
              #datetime = DateTime.strptime("#{date} #{time}#{zone}","%Y-%m-%d %H-%M-%S %z")
              #p datetime
              FileUtils.touch p, :mtime => datetime.to_time                      
              File.rename p, "#{filename_pre}#{date}#{filename_tail}"
              break
           end
        end
    end
end

# read params
if ARGV.size == 0
    usage
    exit 1
else
    case ARGV[0]
        when "-n","--new_post"
            new_post
        when "-u","--update"
            update
        when "-d","--debug"
            debug
        when /\-[0-9]/
            recent((ARGV[0][1,ARGV[0].size]).to_i)
        when "-h","--hygiene-timestamp"
            hygiene_timestamp
        when "-s","--search"
            search(ARGV[1])  
        when "-e","--edit"
            edit(ARGV[1])
        else
            puts "Error: invalid options #{p}!"
            usage
            exit
    end
end



