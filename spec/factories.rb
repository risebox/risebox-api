FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@risebox.co"
  end
end