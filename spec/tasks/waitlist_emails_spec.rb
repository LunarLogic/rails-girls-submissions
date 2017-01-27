# Testing rake tasks method found at:
# http://carlosplusplus.github.io/blog/2014/02/01/testing-rake-tasks-with-rspec/
# https://robots.thoughtbot.com/test-rake-tasks-like-a-boss

require 'rails_helper'
require 'rake'

describe 'scheduled:waitlist_emails' do
  let(:rake)      { Rake::Application.new }
  let(:task_name) { self.class.top_level_description }
  let(:task_path) { "lib/tasks/scheduled/waitlist_emails" }
  let(:waitlist_submissions_acceptor) { instance_double WaitlistSubmissionsAcceptor }
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
    expect(WaitlistSubmissionsAcceptor).to receive(:build).and_return(waitlist_submissions_acceptor)
    expect(waitlist_submissions_acceptor).to receive(:call)
    subject.invoke
  end
end
