# Testing rake tasks method found at:
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# https://robots.thoughtbot.com/test-rake-tasks-like-a-boss

require 'rails_helper'
require 'rake'

describe 'scheduled:invite_new_submissions_in_place_of_expired_ones' do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/tasks/scheduled/invite_new_submissions_in_place_of_expired_ones" }
  let(:submisssions_inviter) { instance_double SubmissionsInviter }
  subject         { rake[task_name] }

  def loaded_files_excluding_current_rake_file
    $".reject {|file| file == Rails.root.join("#{task_path}.rake").to_s }
  end

  before do
    Rake.application = rake
    Rake.application.rake_require(task_path, [Rails.root.to_s], loaded_files_excluding_current_rake_file)

    Rake::Task.define_task(:environment)
  end

  it 'calls correct service' do
    expect(SubmissionsInviter).to receive(:new).and_return(submisssions_inviter)
    expect(submisssions_inviter).to receive(:call)
    subject.invoke
  end
end
