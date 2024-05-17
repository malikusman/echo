# frozen_string_literal: true

class CreateEndpoints < ActiveRecord::Migration[7.1]
  def change
    create_table :endpoints, id: false do |t|
      t.string :id, primary_key: true
      t.string :verb, null: false
      t.string :path, null: false
      t.jsonb :response, null: false

      t.timestamps
    end

    add_index :endpoints, [:verb, :path], unique: true
  end
end
