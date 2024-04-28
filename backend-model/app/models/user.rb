class User < ApplicationRecord
  has_many :messages
  has_many :rooms, through: :messages

  def admin?
    name == 'admin'
  end

end
