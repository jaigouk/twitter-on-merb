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
 


  def self.scrape

    merb = 'http://github.com/wycats/merb/commits/1.0.x'
    negotiation = 'http://github.com/wycats/rails/commits/master'
    blog= 'http://yehudakatz.com'

    self.get_commits_and_bark(merb, "edgemerb")
    self.get_commits_and_bark(negotiation, "wycats_rails")
    self.get_blog_and_bark(blog)
  end    
    

#parsing github commits 
  def self.get_commits_and_bark(url, category)
    temp = []      
    @doc  = Nokogiri::HTML(open(url))
    @doc.css('div.human').each do |h|
      h.search('div.message').each {|k| @message = k.content}
      h.search('div.name').each do |k| 
        @name =  (k.content).to_s.strip.gsub(" (author)", "").gsub("(committer)","")
      end
      h.search('div.date').each do |k| 
         @date = k.content
         @new_date = Time.parse(@date.strip)
      end
      h.search('pre a[href]').each do |k| 
       @link =  (k.attributes)
         begin
           @new_link =  ShortURL.shorten("http://github.com" + @link.to_s.strip.gsub("href", ''), :rubyurl)
         rescue  => e
           @new_link =  ShortURL.shorten("http://github.com" + @link.to_s.strip.gsub("href", ''), :tinyurl)
         rescue Timeout::Error => e
          @new_link =  "http://github.com" + @link.to_s.strip.gsub("href", '')
         end
      end
      temp <<{:message => @message, :name => @name, :date => @new_date, :link => @new_link, :category => category}           
    end  
      temp.slice!(4, temp.length) 
      temp.sort_by{|a| a[:date]}.each do |data|
       self.save_this(data)
      end
  end


  
#parsing a blog  
  def self.get_blog_and_bark(url)
      temp = []
      @doc  = Nokogiri::HTML(open(url))
      @doc.css('div.entry').each do |h|
        @name = "Katz"
        h.search('h3.entrytitle').each {|k| @title = k.content }        
        h.search('h3 a[href]').each do |k| 
          @link =  (k.attributes)
           begin
             @new_link =  ShortURL.shorten(@link.to_s.strip.gsub("href", '').gsub('relbookmark',''), :rubyurl)
           rescue  => e
             @new_link =  ShortURL.shorten(@link.to_s.strip.gsub("href", '').gsub('relbookmark',''), :tinyurl)
           rescue Timeout::Error => e
             @new_link = @link.to_s.strip.gsub("href", '').gsub('relbookmark','')
           end          
        end
        h.search('div.meta').each do |k| 
          @date = k.attributes
          @new_date = Time.parse(@date.to_s.strip.gsub(" Posted", "").gsub(" Comments(","").gsub(")",""))
        end
        temp<<{:message => @title, :name => @name, :date=> @new_date, :category => "Katz's blog", :link => @new_link}
      end
      temp.slice!(4, temp.length) 


      temp.sort_by{|a| a[:date]}.each do |data|
       self.save_this(data)
      end
  end


  def self.save_this(data)  
    @tweet = self.new(data)
    if @tweet.save
      puts "succeed to save them"
        begin
         self.post(data)
        rescue Twitter::RESTError => re
          unless re.code == "403"
            puts re
          end
        end #begin-rescue end 
    else
      puts "failed to save them"
    end    
    return @tweet
  end
  
  def self.post(tweet)
    @poster = String.new
    @poster = '[' + tweet[:category] + ']' + tweet[:message] +'('+ tweet[:name]  +')'+ tweet[:link]
     STARLING.set('twitter_post', {:send => @poster})
  end
  


end #class end
