class CreateWords < ActiveRecord::Migration
  def change
    create_table :words do |t|
      t.string :foreign_lang
      t.string :native_lang
      t.boolean :can_foreign
      t.boolean :can_native

      t.timestamps
    end
  end
end
