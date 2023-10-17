require "rails_helper"
require "faker"

FactoryBot.define do
  factory :merchant do
    name { Faker::Company.name }
  end
end

RSpec.describe Merchant, type: :model do
  it "has a valid factory" do
    market = create(:merchant)

    expect(market).to be_valid
  end
end
