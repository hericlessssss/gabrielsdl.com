class ContactMessagesController < ApplicationController
  def new
    @contact_message = ContactMessage.new
  end

  def create
    @contact_message = ContactMessage.new(contact_message_params.merge(locale: I18n.locale, source: "site"))

    if @contact_message.save
      redirect_to contact_path(locale: I18n.locale), notice: t("contact.success")
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :message)
  end
end
