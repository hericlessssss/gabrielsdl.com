require "test_helper"

class ContactMailerTest < ActionMailer::TestCase
  test "new_message sends contact data to Gabriel" do
    contact_message = ContactMessage.create!(
      name: "Editor",
      email: "editor@example.com",
      message: "I want to discuss sample pages.",
      locale: "en",
      source: "site"
    )

    email = ContactMailer.new_message(contact_message)

    assert_equal [ "bielsdldrawing@gmail.com" ], email.to
    assert_equal [ "editor@example.com" ], email.reply_to
    assert_equal "[gabrielsdl.com] Nova mensagem de Editor", email.subject
    assert_match "I want to discuss sample pages.", email.text_part.body.to_s
  end
end
