require 'rails_helper'
require 'rspec/expectations'

RSpec::Matchers.define :have_vacancy? do
  match do |actual|
    actual.has_vacancy?
  end
end

RSpec::Matchers.define :have_vacancy_of do |expected|
  match do |actual|
    actual.vacancy == expected
  end
end

RSpec.describe PurchaseRecord, :type => :model do
  let(:purchase_record) { FactoryGirl.create(:purchase_record) }

  describe 'creating' do

    describe 'a purchase record with no vacancy' do
      it 'should save a purchase record with no vacancy' do
        expect(purchase_record).not_to have_vacancy?
      end
    end

    describe 'a purchase record with seat count of 10' do
      before do
        purchase_record.seat_count = 10
      end

      it 'should save a purchase record with vacancy of 10' do
        expect(purchase_record).to have_vacancy?
        expect(purchase_record).to have_vacancy_of(10)
      end
    end

  end

  describe 'validating' do

    describe 'a purchase record with negative seat count' do
      it 'shall not pass' do
        expect {
          purchase_record.seat_count = -1
          purchase_record.save
        }.not_to change { PurchaseRecord.find(purchase_record.id).seat_count }
      end
    end

    describe 'a purchase record with more seats taken than seat count' do
      it 'shall not pass' do
        expect {
          purchase_record.seats_taken = 1;
          purchase_record.save
        }.not_to change { PurchaseRecord.find(purchase_record.id).seats_taken }
      end
    end

  end
end
