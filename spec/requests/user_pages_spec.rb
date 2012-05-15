require 'spec_helper'

describe "UserPages" do
  describe "GET /user_pages" do
    it "works! (now write some real specs)" do
      visit employees_path
      response.status.should be(200)
    end
  end
end
