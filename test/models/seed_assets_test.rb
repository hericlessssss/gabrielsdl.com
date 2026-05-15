require "test_helper"

class SeedAssetsTest < ActiveSupport::TestCase
  test "portfolio seed assets are versioned" do
    Dir.glob(Rails.root.join("app/assets/images/portfolio/*.jpg")).then do |assets|
      assert_equal 22, assets.size
      assert assets.all? { |asset| File.size(asset) < 2.megabytes }
    end
  end
end
