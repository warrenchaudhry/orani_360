require 'rails_helper'

RSpec.describe "registrations/show", type: :view do
  before(:each) do
    @registration = assign(:registration, Registration.create!(
      :registration_no => "Registration No",
      :email => "Email",
      :first_name => "First Name",
      :last_name => "Last Name",
      :middle_name => "Middle Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Registration No/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Middle Name/)
  end
end
