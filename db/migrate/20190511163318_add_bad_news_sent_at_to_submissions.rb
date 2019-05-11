class AddBadNewsSentAtToSubmissions < ActiveRecord::Migration
  def change
    add_column :submissions, :bad_news_sent_at, :datetime
  end
end
