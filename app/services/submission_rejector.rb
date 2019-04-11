class SubmissionRejector
  RULES = [
    Rules::EnglishRule.new,
    Rules::FirstTimeRule.new,
    Rules::AdultRule.new,
  ]

  def initialize(rules = RULES)
    @rules = rules
  end

  def reject_if_any_rules_broken(submission)
    submission.rejected = true if any_rules_broken?(submission)
  end

  private

  def any_rules_broken?(submission)
    @rules.any? { |rule| rule.broken?(submission) }
  end
end
