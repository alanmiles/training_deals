class AddCancelledToEvents < ActiveRecord::Migration
  def change
    add_column :events, :cancelled, :boolean, default: false   #use cancelled instead of deletion when
    														   #event already has user interest.
  end
end
