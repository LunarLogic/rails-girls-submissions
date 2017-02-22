class RatesController < ApplicationController
  def create
    value = Integer(params[:value])
    submission_id = Integer(params[:submission_id])
    user_id = current_user.id

    rate_creator = RateCreator.build(value, submission_id, user_id)
    result = rate_creator.call
    if result.success
      redirect_to request.referer, notice: 'Rate was successfully created.'
    else
      redirect_to request.referer, notice: 'Error: rate could not be created'
    end
  end
end
