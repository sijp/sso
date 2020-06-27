class CreateAccessCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :access_codes do |t|
      t.text :code
      t.numeric :client_id
      t.numeric :user_id

      t.timestamps
    end
  end
end
