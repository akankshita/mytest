class UserMailer < ActionMailer::Base
  def ipnotavaialable()
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "akankshita.satapathy@php2india.com", :subject => "Ip Not Available")
    #mail(:to => @customer_details.email, :subject => "Ip Not Available")
    #mail(:to => "daniel@php2india.com", :subject => "Ip Not Available")
  end
  def incorrecttime()
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    mail(:to => "akankshita.satapathy@php2india.com", :subject => "Incorrect Time")
    #mail(:to => "daniel@php2india.com", :subject => "Incorrect Time")
    #mail(:to => @customer_details.email, :subject => "Incorrect Time")
  end

end
