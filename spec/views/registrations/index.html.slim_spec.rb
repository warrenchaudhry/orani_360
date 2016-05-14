require 'rails_helper'

RSpec.describe "registrations/index", type: :view do
  before(:each) do
    assign(:registrations, [
      Registration.create!(
        :registration_no => "Registration No",
        :email => "Email",
        :first_name => "First Name",
        :last_name => "Last Name",
        :middle_name => "Middle Name"
      ),
      Registration.create!(
        :registration_no => "Registration No",
        :email => "Email",
        :first_name => "First Name",
        :last_name => "Last Name",
        :middle_name => "Middle Name"
      )
    ])
  end

  it "renders a list of registrations" do
    render
    assert_select "tr>td", :text => "Registration No".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Middle Name".to_s, :count => 2
  end
end
