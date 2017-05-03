module ActiveRecord
  class Base
    def self.contains(hash)
      where("#{hash.keys.first.to_s} LIKE ?", '%' + hash.values.first.to_s + '%')
    end

    def contains?(hash)
      Regexp.new(hash.keys.first.to_s) === eval("ingredient.#{hash.values.first}")
    end
  end
end
