require 'spec_helper'

describe "Pages" do
  let(:base_title) { "Worktime Tracker" }

  subject { page }
  describe "Home page" do
    before { visit root_path }

    it { should have_selector("h1", :text => "Welcome") }
    it { should have_selector("title", :text => "#{base_title} | Home") }
  end

  describe "Contact page" do
    before { visit contact_path }

    it  { should have_selector("h1", :text => "Contact") }
    it { should have_selector("title", :text =>  "#{base_title} | Contact") }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector("h1", :text => "About Us") }
    it { should have_selector("title", :text =>  "#{base_title} | About") }
  end
end
