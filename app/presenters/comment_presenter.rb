class CommentPresenter
  def initialize(comment, user)
    @comment = comment
    @user = user
  end

  def body
    @comment.body
  end

  def user_nickname
    @user.nickname
  end

  def timestamp
    @comment.updated_at
  end
end
