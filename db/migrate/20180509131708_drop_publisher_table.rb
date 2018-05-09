class DropPublisherTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :publishers
  end
end
