class CreateArActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :ar_activities do |t|
      t.references :trackable, polymorphic: true
      t.references :owner, polymorphic: true
      t.string :key
      t.string :data

      t.timestamps
    end
  end
end
