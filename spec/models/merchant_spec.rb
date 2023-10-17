require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "relationships" do
    it { should have_many :items }
  end
  
  describe "validations" do
    it { should validate_presence_of :name }
  end

  it "has a valid factory" do
    merchant = create(:merchant)

    expect(merchant).to be_valid
  end
end
