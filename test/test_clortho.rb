require 'helper'

class TestClortho < Test::Unit::TestCase
  def setup
    @posts = [
    (@fridge = Post.new( title: 'Is your refrigerator running? Better catch it',
                                    body: @lipsum,
                                    authors: ['Thomas Mann', 'Jim Byrd'])),
    (@colonial =    Post.new(  title: 'The Colonial: In Full Swing',
                                    body: @lipsum,
                                    authors: ['Rebecca Simmons']))
                ]
    save_posts
  end
  
  should 'have a body_keywords field' do
    @posts.each do |post|
      assert post.respond_to? :body_keywords
      assert post.respond_to? :body_keywords_array
    end
  end
  
  private
  def save_posts
    @posts.each{ |post| post.save }
  end
  
end
