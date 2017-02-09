class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.column :value, :integer, default: 0
      t.references :question, index: true, foreign_key: true
      t.references :submission, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
