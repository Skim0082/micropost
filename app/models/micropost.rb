class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  validate  :picture_size
  
  private
  
    # Validates the size of an uploaded pictured
    def picture_size
      if picture.size > 3.megabytes
        errors.add(:picture, "size should be less than 3MB")
      end
    end
end
