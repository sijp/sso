class CreateUrlWhitelists < ActiveRecord::Migration[6.0]
  def change
    create_table :url_whitelists do |t|
      t.numeric :client_id
      t.text :url

      t.timestamps
    end
  end
end
