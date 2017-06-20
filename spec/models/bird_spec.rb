require 'rails_helper'

RSpec.describe Bird, type: :model do
  context 'Definitions' do
    it { is_expected.to be_mongoid_document }

    it 'should have attribute presence validation' do
      is_expected.to validate_presence_of(:name)
      is_expected.to validate_presence_of(:family)
      is_expected.to validate_presence_of(:continents)
      is_expected.to validate_presence_of(:added)
      is_expected.to validate_presence_of(:visible)
    end

    it 'should match the attribute type' do
      is_expected.to have_field(:name).of_type(String)
      is_expected.to have_field(:family).of_type(String)
      is_expected.to have_field(:continents).of_type(Array)
      is_expected.to have_field(:added).of_type(Time)
      is_expected.to have_field(:visible).of_type(Mongoid::Boolean)
    end

    it 'should match default value' do
      is_expected.to have_field(:visible).with_default_value_of(false)
      # is_expected.to have_field(:added).with_default_value_of(Time.zone.now)
    end

    it 'should have index' do
      is_expected.to have_index_for(visible: 1)
    end
  end

  describe 'New record' do
    context 'failure cases' do
      it 'should give blank errors' do
        bird = Bird.create
        expect(bird).not_to be_valid
        expect(bird.errors[:name]).to include("can't be blank")
        expect(bird.errors[:family]).to include("can't be blank")
        expect(bird.errors[:continents]).to include("can't be blank")
      end
    end

    context 'happy cases' do
      before(:each) do
        @name = 'Pigeon'
        @family = 'Doves'
        @continents = ['Asia']
        @bird = Bird.new(name: @name, family: @family, continents: @continents)
      end

      it 'should create record' do
        expect{@bird.save}.to change{Bird.count}.by(1)
        expect(@bird.name).to eq(@name)
        expect(@bird.family).to eq(@family)
        expect(@bird.continents).to eq(@continents)
      end

      it 'should save bird with default values' do
        expect(@bird.save).to eq(true)
        expect(@bird.visible).to eq(false)
        expect(@bird.added).to be_within(1.second).of Time.zone.now
      end

      it 'should save with assigned values' do
        @bird.visible = true
        @bird.added = 1.day.ago
        expect(@bird.save).to eq(true)
        expect(@bird.visible).to eq(true)
        expect(@bird.added).not_to be_within(10.second).of Time.zone.now
        expect(@bird.added).to be_within(10.second).of 1.day.ago
      end

      it 'should save unique continents' do
        continents = ['Asia', 'Asia']
        @bird.continents = continents
        @bird.save
        @bird.reload
        expect(@bird.continents).to eq(continents.uniq)
      end
    end
  end
end
