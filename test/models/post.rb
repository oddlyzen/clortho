class Post
  include MongoMapper::Document
  include MongoMapper::Plugins::Clortho
  
  key :title,   String
  key :body,    String
  key :summary, String
  key :authors, Array
  
  searchable :summary       # works with one...
  searchable :body, :title  # or multiple arguments
  
end
