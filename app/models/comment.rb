class Comment < ApplicationRecord
  belongs_to :submission
  belongs_to :user

  validates :body, length: { in: 1..140 }
end
