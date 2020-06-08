class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto'

    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :username, null: false
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :username
    add_index :users, :reset_password_token, unique: true
  end
end
