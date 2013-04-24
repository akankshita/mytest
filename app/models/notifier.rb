class Notifier < ActionMailer::Base
  #default :from => "from@example.com"
    def welcome()
   # attachments['free_book.pdf'] = File.read('path/to/file.pdf')
    recipients    'akankshita.satapathy@php2india.com'
    from          "My Awesome Site Notifications <notifications@example.com>"
    subject       "Welcome to My Awesome Site"
    sent_on       Time.now
    body          { "http://example.com/login"}
    content_type  'text/html'
  end
  def ipnotavaialable()
    recipients    'akankshita.satapathy@php2india.com'
    from          "Emm Customerpanel <notifications@example.com>"
    subject       "Ip Not Available"
    sent_on       Time.now
    body          { "http://example.com/login"}
    content_type  'text/html'
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
    #mail(:to => "akankshita.satapathy@php2india.com", :subject => "Ip Not Available")
    #mail(:to => @customer_details.email, :subject => "Ip Not Available")
    #mail(:to => "daniel@php2india.com", :subject => "Ip Not Available")
  end
  def incorrecttime()
    recipients    'akankshita.satapathy@php2india.com'
    from          "Emm Customerpanel <notifications@example.com>"
    subject       "In Correct Time"
    sent_on       Time.now
    body          { "http://example.com/login"}
    content_type  'text/html'
    #@user = user
    #attachments["rails.png"] = File.read("#{Rails.root}/public/images/rails.png")
   # mail(:to => "akankshita.satapathy@php2india.com", :subject => "Incorrect Time")
    #mail(:to => "daniel@php2india.com", :subject => "Incorrect Time")
    #mail(:to => @customer_details.email, :subject => "Incorrect Time")
  end

end
