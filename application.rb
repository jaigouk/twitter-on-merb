class TwitterOnMerb < Merb::Controller
 

#  cache :commits, :about
  def _template_location(action, type = nil, controller = controller_name)
    controller == "layout" ? "layout.#{action}.#{type}" : "#{action}.#{type}"
  end

#shows twitter
  def index
    render   
  end

#aggregate rss feeds and edge merb rdoc
  def commits
    
    render
  end
 
# just another plain html   
  def about
    render 
  end


end

