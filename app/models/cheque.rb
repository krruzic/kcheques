class Cheque < ActiveRecord::Base
      scope :person, -> (name) { where(name: name) } # filter by name
end
