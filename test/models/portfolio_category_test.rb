require "test_helper"

class PortfolioCategoryTest < ActiveSupport::TestCase
  test "returns translated name for current locale" do
    category = PortfolioCategory.create!(slug: "sample-pages", sort_order: 1)
    category.translations.create!(locale: "pt", name: "Sample pages")
    category.translations.create!(locale: "en", name: "Sample pages")

    I18n.with_locale(:pt) do
      assert_equal "Sample pages", category.name
    end
  end

  test "requires unique slug" do
    PortfolioCategory.create!(slug: "illustrations", sort_order: 1)
    duplicate = PortfolioCategory.new(slug: "illustrations", sort_order: 2)

    assert_not duplicate.valid?
  end
end
