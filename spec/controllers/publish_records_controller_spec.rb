require 'rails_helper'

RSpec.describe PublishRecordsController, type: :controller do
  let(:authorized_user) { FactoryGirl.create(:user, system_role_id: 1) }
  let(:unauthorized_user) { FactoryGirl.create(:user, system_role_id: 5) }
  let(:course) { FactoryGirl.create(:course) }
  let(:publish_record) { FactoryGirl.create(:publish_record, course: course, published: true) }

  describe 'POST update' do

    context 'when user is not authorized' do
      before do
        sign_in unauthorized_user
      end

      it 'should redirect to access denied page' do
        post :update, course_id: course.id, publish_record_id: publish_record.id
        expect(response).to redirect_to(access_denied_path)
      end
    end

    context 'with validate data' do
      before do
        sign_in authorized_user
        @valid_data = {
            course_id: course.id,
            publish_record_id: publish_record.id,
            publish_record: {
                price_per_seat: 1,
                published: false
            }
        }
      end

      it 'should update existing publish record' do
        post :update, @valid_data
        publish_record.reload
        expect(flash[:error]).to be_nil
        expect(publish_record.price_per_seat).to eq(1)
        expect(publish_record.published).to eq(false)
      end
    end

    context 'with invalid data' do
      before do
        sign_in authorized_user
      end

      context "for publish_record doesn't belong to course" do
        let(:course2) { FactoryGirl.create(:course) }
        let(:publish_record2) { FactoryGirl.create(:publish_record, course: course2) }

        before do
          publish_record
          @invalid_data = {
              course_id: course.id,
              publish_record_id: publish_record2.id,
              publish_record: {
                  price_per_seat: 2,
                  published: false
              }
          }
        end

        it 'should not change the correct publish record and flash error message' do
          post :update, @invalid_data
          publish_record.reload
          expect(flash[:error]).to eq('Validation failed: Course has already been taken')
          expect(publish_record.price_per_seat).to eq(0)
          expect(publish_record.published).to eq(true)
        end
      end

      context 'for new publish record contains invalid data' do
        before do
          @invalid_data = {
              course_id: course.id,
              publish_record_id: publish_record.id,
              publish_record: {
                  price_per_seat: -1,
                  published: false
              }
          }
        end

        it 'should not change the correct publish record and flash error message' do
          post :update, @invalid_data
          publish_record.reload
          expect(flash[:error]).to eq('Validation failed: Price per seat must be greater than or equal to 0')
          expect(publish_record.price_per_seat).to eq(0)
          expect(publish_record.published).to eq(true)
        end
      end

    end

  end

end