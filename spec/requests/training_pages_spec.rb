require 'spec_helper'

describe 'TrainingPages' do
  subject { page }
  let(:admin) { FactoryGirl.create(:admin) }
  let(:student) { FactoryGirl.create(:student) }
  let(:course) { FactoryGirl.create(:course) }

  describe 'Training admin pages' do
    before do
      sign_in admin
      create_course course
      click_link 'Trainings'
    end

    describe 'training display' do
      it { should have_link('New Training') }
      it { should have_content('Overview') }
    end

    describe 'training creation' do
      before do
        click_link 'New Training'
      end

      describe 'with invalid information' do
        it 'should not create a training' do
          expect { click_button 'Create Training' }.not_to change(Assessment.training, :count)
        end
      end

      describe 'with valid information' do
        before do
          fill_in 'Title', with: 'Test Training'
        end

        it 'should create a training' do
          expect { click_button 'Create Training' }.to change(Assessment.training, :count).by(1)
        end
      end
    end
  end

  describe 'Training student pages' do
    subject { page }
    let(:ongoing_training) { FactoryGirl.create(:ongoing_training) }
    let(:overdue_training) { FactoryGirl.create(:overdue_training) }
    let(:no_bonus_training) { FactoryGirl.create(:no_bonus_training) }
    before do
      sign_in admin
      create_course course
      create_training course, ongoing_training
      create_training course, overdue_training
      create_training course, no_bonus_training
      course_enrol_student course, student
      sign_out
      sign_in student
      click_link 'Trainings'
      show_page
      pp Assessment.all#fd
    end

    describe 'training display' do
      it { should_not have_link('New Training') }
    end

  end

end
