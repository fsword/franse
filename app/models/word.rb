class Word < ActiveRecord::Base

  scope :learn_by, lambda{|record_type| where("can_#{record_type}".to_sym => false)}
  validates_uniqueness_of :foreign_lang, :native_lang 
end
