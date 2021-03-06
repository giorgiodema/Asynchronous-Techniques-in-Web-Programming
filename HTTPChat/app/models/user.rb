class User < ApplicationRecord
  #upload user image using carrierwave
  mount_uploader :image, ImageUploader
  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable
         #:confirmable, :recoverable

  #validazione di attributi
  validates :name, presence: true
  validates :surname, presence: true
  validates :username, length: { minimum:2}, presence: true

  validates_uniqueness_of :username

  validates_integrity_of  :image
  validates_processing_of :image

  #ruoli utente
  ROLES = %i[booklover banned admin superadmin]

  def chats
    Chat.where("owner_id = ? OR guest_id = ?", self.id, self.id)
  end

  def self.setRole(id, new_role)
    user = User.find(id)
    user.role = new_role
    user.save
  end


end
