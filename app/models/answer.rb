class Answer < ActiveRecord::Base
  belongs_to :submission
  belongs_to :question

  enum value: {
    not_at_all: 0,
    a_little_bit: 1,
    ok: 2,
    well: 3
  }
end
