class EmailInvite < ActiveRecord::Base
  validates_presence_of     :emails
  validates_email_format_of :emails, :on => :create
end
