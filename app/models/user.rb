class User < ActiveRecord::Base
  has_many :authorizations
  has_many :tweets
  validates :name, :nickname, :presence => true
  # mount_uploader :graph, GraphUploader
end
