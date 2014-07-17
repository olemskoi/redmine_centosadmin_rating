class AddMustRateSendedToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :must_rate_sended, :boolean, default: false, null: false
  end
end
