Conclave
=========

tog_conclave is a plugin for managing events in your site. It's not intended for managing conferences with conferences, authors and payment gateway (yet, and probably never). It's just to to list events and set record user's attendance.


Included functionality
----------------------

* Event list
* Date navigation with an ajax calendar (calendar customizable with styles)
* Attendance management
* Event capacity limit
* Google Maps geolocalization of events (Thanks to Surat Pyari, from Vinsol - http://www.vinsol.com)
* I18n (date and time i18n based on Rails 2.2 support for il8n)

Resources
=========

Plugin requirements
-------------------

* [http://github.com/tog/tog/wikis/3rd-party-plugins-seo\_urls](http://github.com/tog/tog/wikis/3rd-party-plugins-seo\_urls)
* google-geocode <pre>gem install google-geocode</pre>
* ym4r_gm <pre>ruby script/plugin install svn://rubyforge.org/var/svn/ym4r/Plugins/GM/trunk/ym4r_gm</pre>
* later_dude <pre>ruby script/plugin install git://github.com/clemens/later_dude.git</pre>

Note: ym4r_gm seems to have a problem with Rails 2.2. But it can be resolved easily: http://railsforum.com/viewtopic.php?id=24839

Install
-------

  
* Install plugin form source:

<pre>
ruby script/plugin install git//github.com:tog/tog_conclave.git
</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_tog_conclave
</pre>

	  with the following content:

<pre>
class InstallTogConclave < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_conclave", 6
  end

  def self.down
    migrate_plugin "tog_conclave", 0
  end
end
</pre>

* Add tog_conclave's routes to your application's config/routes.rb

<pre>
map.routes_from_plugin 'tog_conclave'
</pre> 

* Get an google api key from

For a host diferent thant localhost, you will need to get an API key for Google Maps from 

[http://code.google.com/apis/maps/signup.html](http://code.google.com/apis/maps/signup.html)

and replace the existing key for your environment with your key in config/gmaps_api_key.yml

* And finally...

<pre> 
rake db:migrate
</pre> 


More
-------

[http://github.com/tog/tog\_conclave]:(http://github.com/tog/tog_conclave)

[http://github.com/tog/tog\_conclave/wikis](http://github.com/tog/tog_conclave/wikis)


Copyright (c) 2008-2009 Keras Software Development, released under the MIT license
