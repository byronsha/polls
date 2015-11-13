class Poll < ActiveRecord::Base
  belongs_to :author,
    foreign_key: :author_id,
    primary_key: :id,
    class_name: "User"

  has_many :questions,
    foreign_key: :poll_id,
    primary_key: :id,
    class_name: "Question"

  validates :title, presence: true
  validates :author_id, presence: true
end
