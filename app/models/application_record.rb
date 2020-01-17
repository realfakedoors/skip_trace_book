class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  def feed
    Post.where(postable: self)
  end
end
