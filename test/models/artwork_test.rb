require "test_helper"

class ArtworkTest < ActiveSupport::TestCase
  test "falls back to slug when translation is missing" do
    category = PortfolioCategory.create!(slug: "illustrations", sort_order: 1)
    artwork = Artwork.create!(
      slug: "venom-2025",
      portfolio_category: category,
      visibility: "public",
      sort_order: 1
    )

    assert_equal "Venom 2025", artwork.title
    assert_equal "Venom 2025", artwork.alt_text
  end
end
