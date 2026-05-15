class ContactMailer < ApplicationMailer
  def new_message(contact_message)
    @contact_message = contact_message

    mail(
      to: ENV.fetch("CONTACT_TO_EMAIL", "bielsdldrawing@gmail.com"),
      reply_to: @contact_message.email,
      subject: "[gabrielsdl.com] Nova mensagem de #{@contact_message.name}"
    )
  end
end
