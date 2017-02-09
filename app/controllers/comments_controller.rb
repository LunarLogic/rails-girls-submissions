class CommentsController < ApplicationController
  def create
    submission_id = params[:submission_id]

    comment_creator = CommentCreator.build(comment_params[:body], submission_id, current_user.id )
    result = comment_creator.call

    if result.success
      redirect_to submission_path(submission_id), notice: 'Comment was successfully created.'
    else
      render "submissions/show", locals: {
        submission: Submission.find(submission_id),
        comment: result.object,
        comment_presenters: CommentPresenter.collection(submission.comments),
        rate_presenters: RatePresenter.collection(submission.rates)
      }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
