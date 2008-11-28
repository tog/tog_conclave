module GG
require 'google_geocode'    
  def gg
    @gg ||= GoogleGeocode.new YAML.load_file(RAILS_ROOT+"/vendor/plugins/tog_conclave/config/gmaps_api_key.yml") [RAILS_ENV]
  end
  
end
