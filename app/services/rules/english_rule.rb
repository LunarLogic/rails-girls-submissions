module Rules
  class EnglishRule
    def broken?(submission)
      submission.english == "none"
    end
  end
end
