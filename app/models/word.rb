class Word < ActiveRecord::Base

  default_scope where(:remember_1_at => nil)

  scope :learn_by, lambda{|record_type| where("can_#{record_type}".to_sym => false)}
  validates_uniqueness_of :foreign_lang, :native_lang 
  
  def archieve cycle_num
    self.update_attribute "remember_#{cycle_num}_at", Time.new
  end
end
