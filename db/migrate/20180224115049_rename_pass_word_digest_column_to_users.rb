class RenamePassWordDigestColumnToUsers < ActiveRecord::Migration[5.1]
  def change
  	rename_column :users, :pass_word_digest, :password_digest
  end
end
