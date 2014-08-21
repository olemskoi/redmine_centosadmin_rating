class RenameCentosRatingsToStaffRatings < ActiveRecord::Migration
  def change
    rename_table :centos_ratings, :staff_ratings
  end
end