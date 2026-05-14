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
    assert_select "title", text: "Gabriel SDL | Comic artist"
    assert_select "meta[name='description'][content='Sequential art, sample pages, illustrations, covers, and commissions by Gabriel SDL.']", count: 1
    assert_select "meta[property='og:title'][content='Gabriel SDL | Comic artist']", count: 1
    assert_select "link[rel='alternate'][hreflang='pt']", count: 1
    assert_select "h1", text: /Sequential art/
    assert_select ".halftone-field"
    assert_select ".scratch-line"
    assert_select "a.w-full", text: "View portfolio"
  end

  test "about renders artist identity" do
    get about_path(locale: :en)

    assert_response :success
    assert_select "img[alt='Illustrated avatar of Gabriel SDL holding a pencil.']"
    assert_select "img[alt='Gabriel SDL signature mark.']"
    assert_select "dd", text: "Sequential pages"
    assert_select "dd", text: "Perseverance"
  end

  test "portuguese copy is readable" do
    get about_path(locale: :pt)

    assert_response :success
    assert_includes response.body, "histórias em quadrinhos"
    assert_includes response.body, "lápis"
    assert_includes response.body, "Perseverança"
    assert_no_match(/Ã|Â|�/, response.body)
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

  test "contact renders direct links and stores valid message" do
    get contact_path(locale: :en)

    assert_response :success
    assert_select "a[href='mailto:contact@gabrielsdl.com']", text: "contact@gabrielsdl.com"
    assert_select "a[href='https://www.instagram.com/gskovu_/']", text: "@gskovu_"

    assert_difference "ContactMessage.count", 1 do
      post contact_messages_path(locale: :en), params: {
        contact_message: {
          name: "Editor",
          email: "editor@example.com",
          message: "I want to discuss sample pages."
        }
      }
    end

    assert_redirected_to contact_path(locale: :en)
  end

  test "contact rejects invalid message" do
    post contact_messages_path(locale: :en), params: {
      contact_message: {
        name: "",
        email: "invalid",
        message: ""
      }
    }

    assert_response :unprocessable_content
    assert_select "li", minimum: 1
  end
end
