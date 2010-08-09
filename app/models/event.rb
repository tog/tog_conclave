# == Schema Information
# Schema version: 20100622215122
#
# Table name: events
#
#  id                :integer         not null, primary key
#  title             :string(255)
#  description       :text
#  start_date        :date
#  end_date          :date
#  start_time        :time
#  end_time          :time
#  url               :string(255)
#  venue             :string(255)
#  venue_link        :string(255)
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  capacity          :integer         default(-1)
#  venue_address     :string(255)
#  site_wide         :boolean
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  icon_updated_at   :datetime
#  moderated         :boolean
#
class Event < ActiveRecord::Base
  
  include GG
  acts_as_taggable
  seo_urls
  belongs_to :owner, :class_name =>'User', :foreign_key =>'user_id'
  has_many   :attendances,      :dependent => :destroy
  has_many   :attendees,        :through => :attendances, :source => :user, :conditions => ['attendances.status = ?', Attendance::STATUS_ACCEPTED]
  validates_presence_of :title, :description, :venue, :start_date, :end_date, :start_time, :end_time
  
  record_activity_of :owner
  
  named_scope :upcoming, lambda { |*args| { :conditions => ['end_date >= ?', args.first || Date.today], :order => 'start_date asc, start_time asc' } }  
  named_scope :past, lambda { |*args| { :conditions => ['start_date <= ?', args.first || Date.today], :order => 'start_date desc, start_time desc' } }  
  named_scope :site, :conditions => ['site_wide = ?', true]
  
  before_create :set_default_icon
  
  UNLIMITED_CAPACITY = -1

  has_attached_file :icon, {
    :url => "/system/:class/:attachment/:id/:style_:basename.:extension",
    :styles => {
      :big    => Tog::Plugins.settings(:tog_conclave, "event.image.versions.big"),
      :medium => Tog::Plugins.settings(:tog_conclave, "event.image.versions.medium"),
      :small  => Tog::Plugins.settings(:tog_conclave, "event.image.versions.small"),
      :tiny   => Tog::Plugins.settings(:tog_conclave, "event.image.versions.tiny")
    }}.merge(Tog::Plugins.storage_options)
      
  def register(user, invitation=false)
    params = {:user_id => user.id} 
    return false if self.attendances.find :first, :conditions => params
    self.attendances.create params.merge!({:invitation => invitation,
                                           :status => self.moderated? ? Attendance::STATUS_PENDING : Attendance::STATUS_ACCEPTED})
  end
  
  def registered?(user)
    self.attendances.find :first, :conditions => {:user_id => user.id}     
  end
  
  def unregister(user)
    Attendance.delete_all( ["user_id = ? and event_id = ?", user.id, self.id])
  end
  
  def available_capacity
    if(self.capacity)
      self.capacity == UNLIMITED_CAPACITY ? I18n.t('tog_conclave.fields.unlimited') : self.capacity - self.attendances.size
    else
      return 0
    end
  end
  
  def places_left?
    return capacity == UNLIMITED_CAPACITY || available_capacity > 0
  end
  
  def self.site_search(query, search_options={})
    sql = "%#{query}%"
    Event.find(:all, :conditions => ["title like ? or description like ? or venue_address like ?", sql, sql, sql])
  end  

  def starting_time(format="%H:%M")
    I18n.l(start_time, :format => format)
  end
  def ending_time(format="%H:%M")
    I18n.l(end_time, :format => format)
  end
    
  def starting_date(format=:short)
    I18n.l(start_date, :format => format)
  end
  def ending_date(format=:short)
    I18n.l(end_date, :format => format)
  end  
  
  def active?
    Date.today <= self.end_date
  end  
  
  protected
  
    def validate
      if !(start_date && end_date && start_time && end_time) || (start_date > end_date || (start_date == end_date && start_time >= end_time))
        errors.add("end_date", I18n.t("tog_conclave.fields.errors.end_date_before_start_date"))
      end
      loc = gg.locate self.venue_address rescue nil
#      errors.add("venue_address", I18n.t("tog_conclave.fields.errors.venue_address_error")) if loc.nil?
    end
    
    def set_default_icon
      unless self.icon?
        if Tog::Config["plugins.tog_conclave.event.image.default"]
          default_event_icon = File.join(RAILS_ROOT, 'public', 'tog_conclave', 'images', Tog::Config["plugins.tog_conclave.event.image.default"])
          self.icon = File.new(default_event_icon)
        end
      end
    end    

end
