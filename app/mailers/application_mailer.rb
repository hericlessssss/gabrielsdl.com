class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("CONTACT_FROM_EMAIL", "bielsdldrawing@gmail.com")
  layout "mailer"
end
