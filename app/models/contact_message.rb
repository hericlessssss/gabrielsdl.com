class ContactMessage < ApplicationRecord
  STATUSES = %w[new archived].freeze

  validates :name, :email, :message, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :locale, presence: true, inclusion: { in: %w[pt en] }
  validates :status, presence: true, inclusion: { in: STATUSES }
end
