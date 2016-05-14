require 'rails_helper'

RSpec.describe "registrations/edit", type: :view do
  before(:each) do
    @registration = assign(:registration, Registration.create!(
      :registration_no => "MyString",
      :email => "MyString",
      :first_name => "MyString",
      :last_name => "MyString",
      :middle_name => "MyString"
    ))
  end

  it "renders the edit registration form" do
    render

    assert_select "form[action=?][method=?]", registration_path(@registration), "post" do

      assert_select "input#registration_registration_no[name=?]", "registration[registration_no]"

      assert_select "input#registration_email[name=?]", "registration[email]"

      assert_select "input#registration_first_name[name=?]", "registration[first_name]"

      assert_select "input#registration_last_name[name=?]", "registration[last_name]"

      assert_select "input#registration_middle_name[name=?]", "registration[middle_name]"
    end
  end
end
