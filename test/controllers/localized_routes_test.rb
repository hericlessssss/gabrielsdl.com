require "test_helper"

class LocalizedRoutesTest < ActionDispatch::IntegrationTest
  test "root redirects to default locale" do
    get root_path

    assert_redirected_to localized_root_path(locale: :pt)
  end

  test "localized home renders" do
    assert_equal "/en", localized_root_path(locale: :en)

    get localized_root_path(locale: :en)

    assert_response :success
    assert_select "h1", text: /Sequential art/
  end

  test "portfolio renders with category filters" do
    assert_equal "/en/portfolio", portfolio_path(locale: :en)

    PortfolioCategory.create!(slug: "sample-pages", sort_order: 1).tap do |category|
      category.translations.create!(locale: "en", name: "Sample pages")
    end

    get portfolio_path(locale: :en)

    assert_response :success
    assert_select "a", text: "Sample pages"
  end
end
