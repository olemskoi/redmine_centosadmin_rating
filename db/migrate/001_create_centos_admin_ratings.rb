class CreateCentosAdminRatings < ActiveRecord::Migration
  def change
    create_table :centos_admin_ratings do |t|
      t.integer :grade
      t.text :text

      t.references :evaluated
      t.references :evaluator
      t.references :issue
    end

    add_index :centos_admin_ratings, :evaluated_id
    add_index :centos_admin_ratings, :evaluator_id
    add_index :centos_admin_ratings, :issue_id
  end
end
