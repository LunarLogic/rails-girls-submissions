# Testing rake tasks method found at:
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# https://robots.thoughtbot.com/test-rake-tasks-like-a-boss

require 'rails_helper'
require 'rake'

describe 'inviting new submissions in place of expired ones' do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { 'scheduled:invite_new_submissions_in_place_of_expired_ones' }
  let(:task_path) { "lib/tasks/scheduled/invite_new_submissions_in_place_of_expired_ones" }
  let(:setting) { FactoryGirl.build(:setting, available_spots: 3) }
  let!(:to_invite_submission) do
    FactoryGirl.create(
      :submission,
      :with_rates,
      invitation_token: nil,
      invitation_confirmed: false,
      rates_num: setting.required_rates_num,
      rates_val: 2)
  end
  subject         { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
    allow(Setting).to receive(:get).and_return(setting)
  end

  it 'calls correct service' do
    subject.invoke
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
