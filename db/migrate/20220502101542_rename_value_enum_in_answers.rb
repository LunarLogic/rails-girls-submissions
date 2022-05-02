class RenameValueEnumInAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :choice, :integer

    Answer.all.each do |answer|
      answer.choice = answer.value
      answer.save!
    end

    remove_column :answers, :value, :integer
  end
end
