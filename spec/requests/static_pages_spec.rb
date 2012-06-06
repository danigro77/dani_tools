require 'spec_helper'

describe "Static Pages" do

   describe "Home page" do

      it "should have the content 'Dani'" do
         visit '/'
         page.should have_content('Dani')
      end

      it "should have the right title" do
         visit '/'
         page.should have_selector('title', text: "Dani's Tools | Home")
      end
   end

   describe "Help page" do

      it "should have the content 'help'" do
         visit '/help'
         page.should have_content('help')
      end
   end

   describe "About page" do
      it "should have the content 'About'" do
         visit '/about'
         page.should have_content('About')
      end
   end


end
