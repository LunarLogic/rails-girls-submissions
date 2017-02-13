class RemoveDefaultValueFromAnswers < ActiveRecord::Migration
  def change
    change_column_default(:answers, :value, nil)
  end
end
