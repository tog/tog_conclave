Conclave
=========

WORK IN PROGRESS. NOT READED FOR PRIME-TIME YET.

tog_conclave is a plugin for managing events in your site.



Included functionality
----------------------

* Event list
* Calendar/date navigation
* Attendance management
* event capacity limit


Resources
=========

Plugin requirements
-------------------

* [http://github.com/tog/tog/wikis/3rd-party-plugins-acts_as_taggable_on_steroids](http://github.com/tog/tog/wikis/3rd-party-plugins-acts_as_taggable_on_steroids)
* [http://github.com/tog/tog/wikis/3rd-party-plugins-seo\_urls](http://github.com/tog/tog/wikis/3rd-party-plugins-seo\_urls)



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

[http://github.com/tog/tog\_conclave]:(http://github.com/tog/tog_conclave)

[http://github.com/tog/tog\_conclave/wikis](http://github.com/tog/tog_conclave/wikis)


Copyright (c) 2008 Keras Software Development, released under the MIT license
