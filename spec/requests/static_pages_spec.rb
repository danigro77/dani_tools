require 'spec_helper'

describe "Static Pages" do
   subject { page }

   describe "Home page" do
      before { visit root_path }

      it { should have_content('My Tools Collection') }
      it { should have_selector('title', text: full_title('') ) }
      it { should_not have_selector('title', text: "| Home") }

   end

   describe "Help page" do
      before { visit help_path }

      it { should have_content('help') }
      it { should have_selector('title', text: full_title('Help')) }

   end

   describe "About page" do
      before { visit about_path }

      it { should have_content('About') }
      it { should have_selector('title', text: full_title('About')) }

   end

   describe "Contact page" do
      before { visit contact_path }

      it { should have_content('Contact') }
      it { should have_selector('title', text: full_title('Contact')) }

   end


end
