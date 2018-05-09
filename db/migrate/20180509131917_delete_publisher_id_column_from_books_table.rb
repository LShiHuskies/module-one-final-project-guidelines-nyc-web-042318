class DeletePublisherIdColumnFromBooksTable < ActiveRecord::Migration[5.0]
  def change
    remove_column :books, :publisher_id
  end
end
