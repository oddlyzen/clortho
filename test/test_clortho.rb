require 'helper'

class TestClortho < Test::Unit::TestCase
  def setup
    @posts = [
    (@fridge = Post.new( title: 'Is your refrigerator running? Better catch it',
                                    body: Post::LIPSUM,
                                    about: 'Hello a lipsum world',
                                    authors: ['Thomas Mann', 'Jim Byrd'])),
    (@colonial =    Post.new(  title: 'The Colonial: In Full Swing',
                                    body: Post::LIPSUM,
                                    about: 'Hello a lipsum world',
                                    authors: ['Rebecca Simmons']))
                ]
    save_posts
  end
  
  should 'have a all searchable fields, both as a string and array' do
    @posts.each do |post|
      ['summary', 'body', 'title'].each do |word|
        assert post.respond_to? :"#{word}_keywords"
        assert post.respond_to? :"#{word}_keywords_array"
      end
    end
  end
  
  should 'have fields that never evaluate to nil unless supplied field is nil' do
    @posts.each do |post|
      ['summary', 'body', 'title'].each do |word|
        assert !(post.send :"#{word}_keywords").nil?
        assert !(post.send :"#{word}_keywords_array").nil?
      end
    end
  end
  
  should 'have body_keywords equal to LIPSUM' do
    assert_equal Post::LIPSUM, @colonial.body_keywords
    assert_equal Post::LIPSUM, @fridge.body_keywords
  end
  
  should 'have about_keywords equal to "Hello   World"' do
    assert_equal "Hello   world", @colonial.about_keywords
    assert_equal "Hello   world", @fridge.about_keywords
  end
  
  should 'have a search_about_keywords_for field' do
    assert_equal Post.search_about_keywords_for('lipsum'), true
  end
  
  private
  def save_posts
    @posts.each{ |post| post.save }
  end
  
end
