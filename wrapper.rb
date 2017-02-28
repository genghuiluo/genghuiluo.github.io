################################################################
#   Copyright (C) 2017 All rights reserved.
#   
#   Filename：wrapper.rb
#   Creator：Mark Luo
#   Created Date：02/28/2017
#   Description：
#
#   Modified History：
#
################################################################
require 'shellwords'
require 'fileutils'
require 'date'
# usage
def usage
    puts "ruby #{$0} <options> <parameters>"
    puts "e.g. create new post:"
    puts " ruby #{$0} -n/--new-post <title>"
    puts "e.g. commit & push updates:"
    puts " ruby #{$0} -u/--update"
    puts "e.g. debug @localhost:"
    puts " ruby #{$0} -d/--debug"
    puts "e.g. list recent n's posts"
    puts " ruby #{$0} -5 # recent five posts"
    puts "e.g. hygiene timestamp of posts"
    puts " ruby #{$0} -h/--hygiene-timestamp"
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
    Dir.glob("./_posts/*").sort_by{|p| File.mtime(p)}.reverse.first(num).each{|p| puts "#{File.mtime(p)} | #{p}"}
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
    ARGV.each do |p|
        case p
        when "-n","--new_post"
            new_post
            break
        when "-u","--update"
            update
            break
        when "-d","--debug"
            debug
            break
        when /\-[0-9]/
            recent((p[1,p.size]).to_i)
            exit
            break
        when "-h","--hygiene-timestamp"
            hygiene_timestamp
            break
        else
            puts "Error: invalid options #{p}!"
            usage
            exit
        end
    end
end



