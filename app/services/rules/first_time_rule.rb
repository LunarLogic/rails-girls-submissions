module Rules
  class FirstTimeRule
    def broken?(submission)
      !submission.first_time
    end
  end
end
