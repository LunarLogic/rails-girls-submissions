class Question < ActiveRecord::Base
  validates :text, length: { in: 1..140 }
  validates :text, presence: true

  has_many :answers, dependent: :destroy
end
