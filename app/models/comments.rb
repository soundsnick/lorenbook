class Comments < ApplicationRecord
  def self.search(query)
    if query
      where("LOWER(text) LIKE ?", "%#{query.downcase}%")
    end
  end

  def self.get(id)
    if id
      where(postid: "#{id}").order(id: :desc)
    end
  end
end
