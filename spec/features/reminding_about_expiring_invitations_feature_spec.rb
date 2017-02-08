require 'rails_helper'
require 'rake'

describe 'reminding about expiring invitations' do
  let(:rake) { Rake::Application.new }
  let(:task_name) { 'scheduled:remind_about_expiring_invitations'  }
  let(:task_path) { "lib/tasks/scheduled/remind_about_expiring_invitations" }
  let(:setting) { FactoryGirl.build(:setting, available_spots: 1) }
  let!(:submission_expiring_the_next_day) do
    FactoryGirl.create(
      :submission,
      :with_rates,
      invitation_token: 'yyy',
      invitation_token_created_at: 1.week.ago + 1.day + 1.hour,
      invitation_confirmed: false,
      rates_num: setting.required_rates_num,
      rates_val: 4)
  end
  subject { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
    ActionMailer::Base.deliveries.clear
    allow(Setting).to receive(:get).and_return(setting)
  end

  it 'sends reminder email' do
    subject.invoke
    expect(ActionMailer::Base.deliveries.count).to eq(1)
  end
end
