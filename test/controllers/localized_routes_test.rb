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

    category = PortfolioCategory.create!(slug: "sample-pages", sort_order: 1).tap do |category|
      category.translations.create!(locale: "en", name: "Sample pages")
    end
    illustrations = PortfolioCategory.create!(slug: "illustrations", sort_order: 2).tap do |category|
      category.translations.create!(locale: "en", name: "Illustrations")
    end
    artwork = Artwork.create!(
      slug: "runika-page-1",
      portfolio_category: category,
      visibility: "public",
      sort_order: 1
    )
    artwork.translations.create!(
      locale: "en",
      title: "Runika page 1",
      alt_text: "Runika sample page"
    )
    Artwork.create!(
      slug: "venom-2025",
      portfolio_category: illustrations,
      visibility: "public",
      sort_order: 2
    ).translations.create!(
      locale: "en",
      title: "Venom 2025",
      alt_text: "Venom illustration"
    )

    get portfolio_path(locale: :en)

    assert_response :success
    assert_select "nav[aria-label='Portfolio filters']"
    assert_select "a[data-turbo-frame='portfolio_artworks']", text: "Sample pages"
    assert_select "turbo-frame#portfolio_artworks"
    assert_select "p", text: "2 works"
    assert_select "[data-controller='lightbox']"
    assert_select "dialog [data-lightbox-target='title']"
    assert_select "h2", text: "Runika page 1"

    get portfolio_path(locale: :en, category: "sample-pages"), headers: { "Turbo-Frame" => "portfolio_artworks" }

    assert_response :success
    assert_select "turbo-frame#portfolio_artworks"
    assert_select "p", text: "1 work"
    assert_select "h2", text: "Runika page 1"
    assert_select "h2", text: "Venom 2025", count: 0
  end
end
