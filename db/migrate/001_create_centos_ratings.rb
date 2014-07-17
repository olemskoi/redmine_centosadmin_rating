class CreateCentosRatings < ActiveRecord::Migration
  def change
    create_table :centos_ratings do |t|
      t.integer :mark
      t.text :comments
      t.datetime :created_on, null: false

      t.references :evaluated
      t.references :evaluator
      t.references :issue
      t.references :project
    end

    add_index :centos_ratings, :evaluated_id
    add_index :centos_ratings, :evaluator_id
    add_index :centos_ratings, :issue_id
    add_index :centos_ratings, :project_id
    add_index :centos_ratings, :created_on
  end
end
