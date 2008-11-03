require_plugin 'tog_core'
require_plugin 'acts_as_taggable_on_steroids'
require_plugin 'seo_urls'

         
Dir[File.dirname(__FILE__) + '/locale/**/*.yml'].each do |file|
  I18n.load_translations file
end

Tog::Plugins.helpers Conclave::EventsHelper

Tog::Interface.sections(:site).add "Eventos", "/conclave/events"
Tog::Interface.sections(:admin).add "Events", "/admin/conclave/events"

Tog::Plugins.settings :tog_conclave,  'pagination_size' => "10"