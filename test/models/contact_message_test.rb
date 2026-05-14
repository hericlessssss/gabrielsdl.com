require "test_helper"

class ContactMessageTest < ActiveSupport::TestCase
  test "is valid with required fields" do
    message = ContactMessage.new(
      name: "Editor",
      email: "editor@example.com",
      message: "I want to talk about sequential pages.",
      locale: "en"
    )

    assert message.valid?
  end

  test "requires valid email" do
    message = ContactMessage.new(
      name: "Cliente",
      email: "invalid",
      message: "Quero uma commission.",
      locale: "pt"
    )

    assert_not message.valid?
    assert message.errors.added?(:email, :invalid, value: "invalid")
  end
end
