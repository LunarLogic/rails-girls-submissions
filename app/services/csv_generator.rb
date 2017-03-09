class CsvGenerator
  def call(submissions, filename, type = "text/csv")
    column_names = ["full_name", "email"]

    file = CSV.generate do |csv|
      csv << column_names
      submissions.each do |submission|
        csv << submission.attributes.values_at(*column_names)
      end
    end

    Csv.new(file, { filename: filename, type: type })
  end
end
