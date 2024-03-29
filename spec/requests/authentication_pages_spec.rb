require 'spec_helper'

describe "Authentication" do

   subject { page }

# AUTHORIZATION
   describe "authorization" do

   # non-signed-in users
      describe "for non-signed-in users" do
         let(:user) { FactoryGirl.create(:user) }

         describe "before signing in" do
            it {should_not have_selector('title',  text: user.name) }
            it {should_not have_link('My Tools',   href: user_path(user)) }
            it {should_not have_link('Settings',   href: edit_user_path(user)) }
            it {should_not have_link('Sign out',   href: signout_path) }
         end

         describe "when attemting to visit a protected page" do
            before do
               visit edit_user_path(user)
               fill_in "Email",     with: user.email
               fill_in "Password",  with: user.password
               click_button "Sign in"
            end

            describe "after signing in" do
               it "should render the desired protected page" do
                  page.should have_selector('title',   text: full_title('Edit user'))
               end

               describe "when signing in again" do
                  before do
                     visit signin_path
                     fill_in "Email",     with: user.email
                     fill_in "Password",  with: user.password
                     click_button "Sign in"
                  end
                  it "should render the dafault (my tools/profile) page" do
                     page.should have_selector('title', text: user.name) 
                  end
               end
            end
         end
      end
   # wrong user
      describe "as wrong user" do
         let(:user) { FactoryGirl.create(:user) }
         let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
         before { sign_in user }

         describe "visiting Users#edit page" do
            before { visit edit_user_path(wrong_user) }
            it {should_not have_selector('title',   text: full_title('Edit user')) }
         end
         describe "submitting a PUT request to the Users#update action" do
            before { put user_path(wrong_user) }
            specify { response.should redirect_to(root_path) }
         end
      end
   # non-admin user
      describe "as non-admin user" do
         let(:user) { FactoryGirl.create(:user) }
         let(:non_admin) { FactoryGirl.create(:user) }
         before { sign_in non_admin }

         describe "submitting a DELETE request to the Users#destroy action" do
            before { delete user_path(user) }
            specify { response.should redirect_to(root_path) }
         end
      end
   #admin
      describe "as admin user" do
         let(:admin) { FactoryGirl.create(:admin) }
         before { sign_in admin }

         describe "submitting a DELETE request to the Users#destroy action on himself" do
            before { delete user_path(admin) }
            specify { response.should redirect_to(users_path) }
         end
      end
   end

# SIGN IN PAGE
   describe "signin page" do
      before { visit signin_path }

      it {should have_selector('h1',      text: 'Sign in') }
      it {should have_selector('title',   text: 'Sign in') }

   end

# SIGN IN
   describe "sign in" do
      before { visit signin_path }

   # invalid
      describe "with invalid information" do
         before { click_button "Sign in" }

         it {should have_selector('title',   text: 'Sign in') }
         it {should have_selector('div.alert.alert-error',   text: 'Invalid') }
      
         describe "after visiting another page" do
            before { click_link "Home" }

            it {should_not have_selector('div.alert.alert-error') }
         end
      end

   # valid
      describe "with valid information" do
         let(:user) { FactoryGirl.create(:user) }
         before { sign_in user }
   
         it {should     have_selector('title',  text: user.name) }
         it {should     have_link('My Tools',   href: user_path(user)) }
         it {should     have_link('Settings',   href: edit_user_path(user)) }
         it {should     have_link('Sign out',   href: signout_path) }
         it {should_not have_link('Sign in',    href: signin_path) }

         describe "followed by signout" do
            before { click_link "Sign out" } 
            it { should have_link('Sign in') }
         end

      end



   end









end
