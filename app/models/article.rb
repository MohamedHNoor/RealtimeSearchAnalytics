class Article < ApplicationRecord
 validates :name, presence: true, uniqueness: true

 scope :filter_by_name, -> (name) { where('name ILIKE ?', "%#{name}%") }
end
