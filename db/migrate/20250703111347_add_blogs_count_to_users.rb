class AddBlogsCountToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :blogs_count, :integer
  end
end
