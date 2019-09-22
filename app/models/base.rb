class Base < ApplicationRecord
  validates :basename, presence: true, length: { maximum: 50 }
  validates :basetype, presence: true, length: { maximum: 50 }
end
