class CsvController < ApplicationController
  def participants
    participants = SubmissionRepository.new.participants
    csv = CsvGenerator.new.call(participants, 'participants.csv')

    send_data csv.file, csv.properties
  end
end
