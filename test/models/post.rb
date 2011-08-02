class Post
  include MongoMapper::Document
  include MongoMapper::Plugins::Clortho
  
  key :title,   String
  key :body,    String
  key :summary, String
  key :authors, Array
  key :about,   String
  
  searchable :summary       # works with one...
  searchable :body, :title  # ...or multiple arguments...
  searchable :about, :exclude => [:verbs, :adjectives, 'lipsum'] # or options like :exclude.
  
  LIPSUM  = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus porttitor, ipsum a commodo aliquet, 
             velit ligula porttitor eros, sit amet consequat purus massa sit amet quam. Aliquam: tempus magna faucibus 
             lacus ultricies rhoncus. In ut metus purus, at venenatis est. Donec vel--elementum turpis. Nullam feugiat 
             massa quis elit egestas."
  
end
