Conclave
=========

tog_conclave is a plugin for managing events in your site. It's not intended for managing conferences with conferences, authors and payment gateway (yet, and probably never). It's just to to list events and set record user's attendance.

Rails 2.3 required.

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

Install
-------

rake rails:template LOCATION=http://tr.im/tog_conclave_0_5


* Get an google api key from

For a host diferent thant localhost, you will need to get an API key for Google Maps from 

[http://code.google.com/apis/maps/signup.html](http://code.google.com/apis/maps/signup.html)

and replace the existing key for your environment with your key in config/gmaps_api_key.yml



More
-------

[http://github.com/tog/tog\_conclave]:(http://github.com/tog/tog_conclave)

[http://github.com/tog/tog\_conclave/wikis](http://github.com/tog/tog_conclave/wikis)


Copyright (c) 2008-2009 Keras Software Development, released under the MIT license