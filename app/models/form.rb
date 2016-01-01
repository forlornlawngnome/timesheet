class Form < ActiveRecord::Base
  #attr_accessible :name, :archive
  has_and_belongs_to_many :users
  has_many :forms_users, :dependent => :destroy
  
  def self.active
    where(:archive=>false)
  end
  def self.all_required
    where(:archive=>false,:required=>true)
  end
end
