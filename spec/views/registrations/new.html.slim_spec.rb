require 'rails_helper'

RSpec.describe "registrations/new", type: :view do
  before(:each) do
    assign(:registration, Registration.new(
      :registration_no => "MyString",
      :email => "MyString",
      :first_name => "MyString",
      :last_name => "MyString",
      :middle_name => "MyString"
    ))
  end

  it "renders new registration form" do
    render

    assert_select "form[action=?][method=?]", registrations_path, "post" do

      assert_select "input#registration_registration_no[name=?]", "registration[registration_no]"

      assert_select "input#registration_email[name=?]", "registration[email]"

      assert_select "input#registration_first_name[name=?]", "registration[first_name]"

      assert_select "input#registration_last_name[name=?]", "registration[last_name]"

      assert_select "input#registration_middle_name[name=?]", "registration[middle_name]"
    end
  end
end
