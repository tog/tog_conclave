require_plugin 'tog_core'
require_plugin 'seo_urls'
require_plugin 'ym4r-gm'
require_plugin 'later_dude'
require 'g_g'


# We've backported i18n-0.0.1 from rails to Tog, allowing pre-Rails 2.2 to use Backend::Simple
# until they're upgraded is released and we see widespread adoption of it.
require "i18n" unless defined?(I18n)
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_path << file
end
Tog::Plugins.helpers Conclave::EventsHelper

Tog::Interface.sections(:site).add "Events", "/conclave/events"
Tog::Interface.sections(:admin).add "Events", "/admin/conclave/events"
Tog::Interface.sections(:member).add "Events", "/member/conclave/events"

Tog::Plugins.settings :tog_conclave, "pagination_size" => "10",
                                     "event.image.default"         => "default_event_icon.png",
                                     "event.image.versions.big"    => "150x150#",
                                     "event.image.versions.medium" => "100x100#",
                                     "event.image.versions.small"  => "50x50#",
                                     "event.image.versions.tiny"   => "25x25#"

Tog::Search.sources << "Event"
