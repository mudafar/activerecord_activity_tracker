class ArActivity < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  belongs_to :owner, polymorphic: true
end
