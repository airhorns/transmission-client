module Transmission
  class Client
    def initialize(host='localhost',port=9091, username = "", password = "")
      Connection.instance.init(host, port, username, password)
    end
    
    def start_all &cb
      Connection.instance.send('torrent-start', &cb)
    end
    
    def start(id, &cb)
      Connection.instance.send('torrent-start', {'ids' => id.class == Array ? id : [id]}, &cb)
    end
    
    def stop(id, &cb)
      Connection.instance.send('torrent-stop', {'ids' => id.class == Array ? id : [id]}, &cb)
    end
    
    def stop_all &cb
      Connection.instance.send('torrent-stop', &cb)
    end
    
    def remove(id, delete_data = false, &cb)
      Connection.instance.send('torrent-remove', {'ids' => id.class == Array ? id : [id], 'delete-local-data' => delete_data }, &cb)
    end
    
    def remove_all(delete_data = false, &cb)
      Connection.instance.send('torrent-remove', {'delete-local-data' => delete_data }, &cb)
    end

    def add_torrent(a, &cb)
      if a['filename'].nil? && a['metainfo'].nil?
        raise "You need to provide either a 'filename' or 'metainfo'."
      end
      Connection.instance.send('torrent-add', a, &cb)
    end
    
    def add_torrent_by_file(filename, &cb)
      add_torrent({'filename' => filename}, &cb)
    end
    
    def add_torrent_by_data(data, &cb)
      add_torrent({'metainfo' => data}, &cb)
    end
    
    def session &cb
      if cb
        Connection.instance.request('session-get') { |resp| cb.call Session.new resp }
      else
        Session.new Connection.instance.request('session-get')
      end
    end
    
  	def torrents(fields = nil, &cb)
  	  torrs = []
  	  if cb
    	  Connection.instance.request('torrent-get', {'fields' => fields ? fields : Transmission::Torrent::ATTRIBUTES}) { |resp| 
    	    resp['torrents'].each do |t|
    	      torrs << Torrent.new(t)
  		    end
  		    cb.call torrs
		    }
  	  else
    	  data = Connection.instance.request('torrent-get', {'fields' => fields ? fields : Transmission::Torrent::ATTRIBUTES})
    	  data['torrents'].each do |t|
    	    torrs << Torrent.new(t)
  		  end
  		  torrs
	    end
    end
  end
end