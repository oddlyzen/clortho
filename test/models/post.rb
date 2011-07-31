class Post
  include MongoMapper::Document
  include MongoMapper::Plugins::Clortho
  
  key :title,   String
  key :body,    String
  key :authors, Array
  
  search_on :body
  
end
