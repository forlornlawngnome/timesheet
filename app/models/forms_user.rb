class FormsUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :form
  #attr_accessible :user_id, :user, :form_id, :form
  
  validates_presence_of :user
  validates_presence_of :form
  validates_uniqueness_of :form_id, :scope => [:user_id]
end
