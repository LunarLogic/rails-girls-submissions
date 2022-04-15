module Rules
  class AdultRule
    def broken?(submission)
      !submission.adult?
    end
  end
end
