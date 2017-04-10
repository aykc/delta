require 'rails_helper'

RSpec.describe Category, type: :model do
  describe "#create" do
    it "has one after adding one" do
      Category.create name: 'category'
      expect(Category.count).to eq 1
    end
    it "has noone after adding one with no params" do
      Category.create
      expect(Category.count).to eq 0
    end
  end

  describe "#build_option_group" do
    let(:category){ Category.create(name: 'category') }
    # subject{:category}
    it 'has one option group after adding one' do
      category.build_option_group(name: 'group1')
      expect(category.option_groups.count).to eq 1
    end
  end

end
