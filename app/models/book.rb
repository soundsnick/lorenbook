class Book < ApplicationRecord
  def self.search(query)
    if query
      where("LOWER(title) LIKE ? OR LOWER(description) LIKE ? OR LOWER(tags) LIKE ? OR LOWER(category) LIKE ? OR LOWER(author) LIKE ?", "%#{query.downcase}%", "%#{query.downcase}%","%#{query.downcase}%","%#{query.downcase}%", "%#{query.downcase}%")
    end
  end

  def self.category(category)
    if category
      where("LOWER(category) LIKE ?", "%#{category.downcase}%")
    end
  end

  def self.author(author)
    if author
      where("LOWER(author) LIKE ?", "%#{author.downcase}%")
    end
  end

  def self.searchCategory(letter)
    if letter
      where("LOWER(category) LIKE ?", "%#{letter.downcase}%")
    end
  end

end
