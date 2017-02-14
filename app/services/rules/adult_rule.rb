class Rules::AdultRule
  def broken?(submission)
    submission.age < 18
  end
end
