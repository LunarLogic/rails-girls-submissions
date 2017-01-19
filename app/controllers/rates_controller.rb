class RatesController < ApplicationController
  def create
    value = Integer(params[:value])
    submission_id = Integer(params[:submission_id])
    user_id = current_user.id

    rate_creator = RateCreator.build(value, submission_id, user_id)
    result = rate_creator.call
    if !result.success
      flash[:error] = "Something went wrong."
      redirect_to submission_path(submission_id)
    else
      redirect_to submission_path(submission_id), notice: 'Rate was successfully created.'
    end
  end
end
