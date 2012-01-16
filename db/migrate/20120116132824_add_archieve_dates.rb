class AddArchieveDates < ActiveRecord::Migration
  def up
    change_table(:words) do |t|
      t.datetime :remember_1_at
      t.datetime :remember_2_at
      t.datetime :remember_3_at
      t.datetime :remember_4_at
      t.datetime :remember_5_at
    end
  end

  def down
    change_table(:words) do |t|
      t.remove :remember_1_at
      t.remove :remember_2_at
      t.remove :remember_3_at
      t.remove :remember_4_at
      t.remove :remember_5_at
    end
  end
end
