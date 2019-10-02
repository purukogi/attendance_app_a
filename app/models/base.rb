class Base < ApplicationRecord
  validates :basenumber, presence: true, uniqueness: true
  validates :basename, presence: true, length: { maximum: 50 }
  validates :basetype, presence: true, length: { maximum: 50 }
end
