class Tag
  
  include Wisper::Publisher
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  
  field :name, type: String
  
  def create_me(tag: nil)
    update_attrs(tag: tag)
    self.save
    publish(:successful_tag_save_event, self)
  end
  
  def update_me(tag: nil)
    update_attrs(tag: tag)
    self.save
    publish(:successful_tag_save_event, self)
  end
  
  
  def update_attrs(tag: nil)
    self.name = tag[:name]
  end
  
  
end