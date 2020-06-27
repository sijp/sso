class CreateClients < ActiveRecord::Migration[6.0]
  def change
    create_table :clients do |t|
      t.text :name
      t.text :client_id
      t.text :client_secret_hash
      t.text :salt

      t.timestamps
    end
  end
end
