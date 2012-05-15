require 'spec_helper'

describe "Pages" do
  let(:base_title) { "Worktime Tracker" }

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Welcome' }
    let(:page_title) { 'Home' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }

    it { should have_selector("h1", :text => "About Us") }
    it { should have_selector("title", :text =>  "#{base_title} | About") }
  end
end
