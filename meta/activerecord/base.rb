module ActiveRecord
  class Base
    def self.contains(hash)
      where("#{hash.keys.first.to_s} LIKE ?", '%' + hash.values.first.to_s + '%')
    end

    def contains?(hash)
      column = hash.keys.first.to_s
      keyword = hash.values.first.to_s
      Regexp.new(keyword) === eval(column)
    end
  end
end
