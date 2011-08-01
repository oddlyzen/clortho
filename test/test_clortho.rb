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
  
  private
  def save_posts
    @posts.each{ |post| post.save }
  end
  
end
