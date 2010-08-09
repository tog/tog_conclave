Edge
----

* Added optional parameter 'format' to write_event_date helper method
* Fixed problem. events_for_month helper method gets also running events that started and finished in other months
* Initial support for invitations
* Initial support for moderated events
* New helper method to get past events

0.6.0
----

* Fixed forms to include multipart => true for event's icons. Kudos to Jorge Álvarez (cokanan)
* Added helper method to show event's icon (icon_for_event). Kudos to Jorge Álvarez (cokanan)
* Retrieve user attendances from user model
* Fixed template, now copies plugin's resources
* Removed RedCloth requirement from temaplate. This gem is added by tog at installation
* New helper method to get next coming events: coming_events(limit=5)

0.5.0
----

* Support for Rails 2.3.2
* Renamed routes.rb to desert_routes.rb (Rails 2.3 + desert 0.5 support)
* New installation template

0.4.4
----

* First tagged version. Works with tog 0.4.4
