json.array!(@registrations) do |registration|
  json.extract! registration, :id, :registration_no, :email, :first_name, :last_name, :middle_name
  json.url registration_url(registration, format: :json)
end
