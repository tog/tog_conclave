Conclave
=========

tog_conclave is a plugin for managing events in your site.


== Included functionality


Included functionality
----------------------

* Event list
* Calendar navigation
* Attendance management


Resources
=========

Plugin requirements
-------------------

require_plugin 'acts_as_taggable_on_steroids'

* [http://github.com/tog/tog/wikis/3rd-party-plugins-seo\_urls](http://github.com/tog/tog/wikis/3rd-party-plugins-seo\_urls)

ruby script/plugin install git://github.com/patrickelder/calendar.git
./script/generate calendar_styles


Install
-------

  
* Install plugin form source:

<pre>
ruby script/plugin install git//github.com:tog/tog_social.git
</pre>

* Generate installation migration:

<pre>
ruby script/generate migration install_tog_conclave
</pre>

	  with the following content:

<pre>
class InstallTogConclave < ActiveRecord::Migration
  def self.up
    migrate_plugin "tog_conclave", 3
  end

  def self.down
    migrate_plugin "tog_conclave", 0
  end
end
</pre>

* Add tog_social's routes to your application's config/routes.rb

<pre>
map.routes_from_plugin 'tog_conclave'
</pre> 

* And finally...

<pre> 
rake db:migrate
</pre> 

More
-------

[http://github.com/tog/tog\_social]:(http://github.com/tog/tog_social)

[http://github.com/tog/tog\_social/wikis](http://github.com/tog/tog_social/wikis)

[Creating relationships between users](http://github.com/tog/tog_social/wikis/creating-relationships-between-users)

[Showing friends, followers or followings in a portlet](http://github.com/tog/tog_social/wikis/showing-friends-followers-or-followings-in-a-portlet)



Copyright (c) 2008 Keras Software Development, released under the MIT license
