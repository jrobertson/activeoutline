#!/usr/bin/env ruby

# file: activeoutline.rb

require 'drb'
require 'filetree_xml'
require 'polyrex-links'


class ActiveOutline


  class LinkReader
    
    def initialize(filepath, debug: false)
    
      @filepath, @debug = filepath, debug
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
      
      @links = PolyrexLinks.new.import(s)
      @ftx = FileTreeXML.new(s.lines.map {|x| x[/^ *\S+/]}.join("\n"), 
                             debug: @debug)
    end
    
    def reload()
      read @filepath
    end
    
    
  end
  
  def initialize(filepath='outline.txt', host: 'localhost', 
                 port: '60700', debug: false)

    @host, @port = host, port

    @lr = LinkReader.new(filepath, debug: debug)

  end

  def start()

    DRb.start_service "druby://#{@host}:#{@port}", @lr
    DRb.thread.join

  end
end

