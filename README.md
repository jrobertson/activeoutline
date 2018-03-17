# Introducing the activeoutline gem

## Creating the lookup file

The following sample file was created to demonstrate the activeoutline server:

file: outline.txt

<pre>
food http://kitchen.com/food
  fruit [r] http://kitchen.com/fruit
    apples http://kitchen.com/fruit?q=apples
    pears http://kitchen.com/fruit?q=pears
spoons http://kitchen.com/spoons
greeting http://a2.jamesrobertson.eu/do/r/hello
</pre>

## Launching the server

    require 'activeoutline'

    ActiveOutline.new('outline.txt', host: '127.0.0.1').start

## Launching the client

    require 'activeoutline_client'

    ao = ActiveOutlineClient.new host: '127.0.0.1'

    ao.fetch 'food/fruit' #=> "[r] http://kitchen.com/fruit" 
    ao.fetch 'greeting' #=> "hello_1 2018-03-17 14:08:35 +0000" 


Notes:

1. The default port is 60700
2. The [r] represents a redirect which means the server won't read the contents of the location, it will simply pass the link back to the client

## Resources

* activeoutline https://rubygems.org/gems/activeoutline
* activeoutline_client https://rubygems.org/gems/activeoutline_client

activeoutline myoutline outline index drb server client polyrexlinks
