class CsvController < ApplicationController

  def download_accepted
    submissions_accepted = SubmissionRepository.new.accepted
    csv = CsvGenerator.new.call(submissions_accepted, 'accepted.csv')

    send_data csv.file, csv.properties
  end

  def download_waitlist
    submissions_waitlist = SubmissionRepository.new.waitlist
    csv = CsvGenerator.new.call(submissions_waitlist, 'waitlist.csv')

    send_data csv.file, csv.properties
  end

  def download_unaccepted
    submissions_unaccepted = SubmissionRepository.new.unaccepted
    csv = CsvGenerator.new.call(submissions_unaccepted, 'unaccepted.csv')

    send_data csv.file, csv.properties
  end
end
