# transmission-client: A Transmission RPC Client

The goal is to support all requests described in the Transmission [RPC Specifications](http://trac.transmissionbt.com/browser/trunk/doc/rpc-spec.txt).

## Installing
You need to have http://gemcutter.org in you gem sources. To add it you can execute either

	sudo gem install gemcutter
	sudo gem tumble

or

	sudo gem source -a http://gemcutter.org

To install transmission-client:

	sudo gem install hornairs-transmission-client

If you want to use EventMachine (optional) you need to install the eventmachine gem and igrigorik's em-http-request. Right now this is a bad idea because it doesn't support authentication for the transmission-rpc or a few of the request types:
	
	sudo gem install eventmachine
	sudo gem install em-http-request

## Usage
Get a list of torrents and print its file names:

	require 'transmission-client'
	t = Transmission::Client.new('127.0.0.1', 9091, 'transmission', 'secretpassword')
	t.torrents.each do |torrent|
	  puts torrent.name
	end

Currently the event EventMachine driven interface doesn't support all the goodness the regular one does.

	require 'eventmachine'
	require 'transmission-client'

	EventMachine.run do
	  t = Transmission::Client.new
	  EM.add_periodic_timer(1) do
	    t.torrents do |torrents|
	      torrents.each do |tor|
	        puts tor.percentDone
	      end
	    end
	  end
	end

RDoc is still to be written, at the meantime have a look at the code to find out which methods are supported.
