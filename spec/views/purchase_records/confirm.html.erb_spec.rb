require 'rails_helper'

RSpec.describe 'purchase_records/confirm', type: :view do
  let(:user) { FactoryGirl.create(:user, system_role_id: 3) }
  let(:original_course) { FactoryGirl.create(:course) }
  let(:duplicate_course) { FactoryGirl.create(:course, is_original_course: false) }
  let(:publish_record) { FactoryGirl.create(:publish_record, course: original_course) }
  let(:course_purchase) { FactoryGirl.create(:course_purchase, publish_record: publish_record, user: user) }
  let(:not_paid_record) { FactoryGirl.create(:purchase_record, course_purchase: course_purchase, is_paid: false) }
  let(:paid_record) { FactoryGirl.create(:purchase_record, course_purchase: course_purchase, is_paid: true) }

  before do
    sign_in user
    assign(:publish_record, publish_record)
    assign(:course_purchase, course_purchase)
  end

  context 'when not paid' do
    before do
      assign(:purchase_record, not_paid_record)
    end

    it 'should display payment failure title and notice' do
      render
      expect(rendered).to match t('Marketplace.transaction.payment_confirmation.failure_title')
      expect(rendered).to match t('Marketplace.transaction.payment_confirmation.failure_notice')
      # TODO change the url when added to the real view
      expect(rendered).to have_link(t('Marketplace.transaction.payment_confirmation.make_payment_btn_text'),'')
    end
  end

  context 'when just paid' do
    before do
      assign(:has_pending_payment, true)
      assign(:purchase_record, paid_record)
    end

    it 'should display payment success title and notice' do
      render
      expect(rendered).to match t('Marketplace.transaction.payment_confirmation.success_title')
      expect(rendered).to match t('Marketplace.transaction.payment_confirmation.success_notice_format') %
                                    paid_record.seat_count
    end

    context 'when the course has not been duplicated' do
      it 'should contain link to course duplication page' do
        render
        expect(rendered).to have_link t('Marketplace.transaction.payment_confirmation.go_to_course_btn_text'), ''
      end
    end

    context 'when the course has been duplicated' do
      before do
        duplicate_course.course_purchase = course_purchase
      end
      it 'should contain link to the course page' do
        render
        expect(rendered).to have_link t('Marketplace.transaction.payment_confirmation.go_to_course_btn_text'),
                                      course_path(duplicate_course)
      end
    end
  end

  context 'when already paid' do
    before do
      assign(:has_pending_payment, false)
      assign(:purchase_record, paid_record)
    end

    it 'should contain already paid title and notice' do
      render
      expect(rendered).to match t('Marketplace.transaction.payment_confirmation.already_paid_title')
      expect(rendered).to match t('Marketplace.transaction.payment_confirmation.already_paid_notice')
      expect(rendered).to have_link t('Marketplace.transaction.payment_confirmation.go_to_master_course_btn_text'),
                                    course_path(publish_record.course)
    end
  end
end
