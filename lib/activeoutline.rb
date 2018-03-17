#!/usr/bin/env ruby

# file: activeoutline.rb

require 'drb'
require 'filetree_xml'
require 'polyrex-links'


class ActiveOutline


  class LinkReader
    
    def initialize(filepath, debug: false, default_url: nil)
    
      @filepath, @debug, @default_url = filepath, debug, default_url
      read filepath    
      
    end
    
    def ls(path='.')
      @ftx.ls(path).map(&:to_s)
    end
    
    def fetch(uri)

      s, remaining = @links.locate uri
      redirect = s =~ /^\[r\] +/i
      return s if redirect 
      
      contents, _ = RXFHelper.read(s)
      
      return contents
    end
    
    def read(filepath)
      
      s, _ = RXFHelper.read(filepath)      
      puts 's ' + s.inspect if @debug
      
      s2 = if @default_url then
        
        # set a default url for entries which don't have one
        s.lines.map do |x|
          x =~ /:\/\// ? x : x.chomp + ' ' + @default_url \
              + URI.encode(x.strip) + "\n"
        end.join
        
      else
        s
      end
      
      if @debug then
        puts 's2: ' + s2.inspect
        puts 's: ' + s.inspect
      end

      if s2 != s and RXFHelper.writeable?(filepath) then
        RXFHelper.write filepath, s2
      end
      
      @links = PolyrexLinks.new.import(s2)
      @ftx = FileTreeXML.new(s.lines.map {|x| x[/^ *\S+/]}.join("\n"), 
                             debug: @debug)
    end    
    
    def reload()
      read @filepath
    end
    
    
  end
  
  def initialize(filepath='outline.txt', host: 'localhost', 
                 port: '60700', debug: false, default_url: nil)

    @filepath, @host, @port, @debug = filepath, host, port, debug
    @default_url = default_url

  end

  def start()

    lr = LinkReader.new(@filepath, debug: @debug, default_url: @default_url)
    DRb.start_service "druby://#{@host}:#{@port}", lr
    DRb.thread.join

  end
end
