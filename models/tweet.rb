# referenced API.
# http://merbapi.com/classes/Merb/BootLoader/BuildFramework.html
class Tweet
  include DataMapper::Resource

  property :id, Serial
  property :message, Text, :length => 255, :nullable => false, :unique => true
  property :name, String, :length => 20, :nullable => false
  property :category, String, :length => 20
  property :link, String
  property :date, String,:nullable => false, :index => true
  property :created_at,  DateTime
  property :updated_at, DateTime



  def self.recent(start_at = 1.week.ago)
    all(:created_at.gte => start_at, :order => [:created_at.desc])
  end

  def self.latest
    first(:order => [:created_at.desc])
  end  
 



end #class end
