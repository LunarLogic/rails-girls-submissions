class Rules::AdultRule
  def broken?(submission)
    !submission.adult?
  end
end
