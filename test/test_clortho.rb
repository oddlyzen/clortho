require 'helper'

class TestClortho < Test::Unit::TestCase
  def setup
    @fields = ['about', 'summary', 'body', 'title']
    @posts = [
    (@fridge = Post.new( title: 'Is your refrigerator running? Better catch it',
                                    body: Post::LIPSUM,
                                    about: 'Hello were having the lipsum a world',
                                    authors: ['Thomas Mann', 'Jim Byrd'])),
    (@colonial =    Post.new(  title: 'The Colonial: In Full Swing',
                                    body: Post::LIPSUM,
                                    about: 'Hello were having the lipsum a world',
                                    authors: ['Rebecca Simmons']))
                ]
    save_posts
  end
  
  should 'have a all searchable fields, both as a string and array' do
    @posts.each do |post|
      @fields.each do |word|
        assert post.respond_to? :"#{word}_keywords"
        assert post.respond_to? :"#{word}_keywords_array"
      end
    end
  end
  
  should 'have fields that never evaluate to nil unless supplied field is nil' do
    @posts.each do |post|
      @fields.each do |word|
        assert !(post.send :"#{word}_keywords").nil?
        assert !(post.send :"#{word}_keywords_array").nil?
      end
    end
  end
  
  should 'have body_keywords equal to LIPSUM' do
    stripsum = Post::LIPSUM.downcase.gsub(/\b\W/, ' ').strip.gsub(/\s+/, ' ')
    assert_equal stripsum, @colonial.body_keywords
    assert_equal stripsum, @fridge.body_keywords
  end
  
  should 'have about_keywords equal to "Hello world"' do
    assert_equal "hello world", @colonial.about_keywords
    assert_equal "hello world", @fridge.about_keywords
  end
  
  should 'allow searches for specific keywords' do
    assert_equal Post.search_body_keywords_for('ipsum').count, 2
    assert_equal Post.search_about_keywords_for('ipsum').count, 0
    assert_equal Post.search_title_keywords_for('refrigerator').count, 1
  end
  
  # need to strip out punctuation in keywords
  should 'strip out punctuation from array entries' do
    @colonial.body_keywords_array.each do |keyword|
      flunk if keyword =~ /^A-Za-z0-9\s/
    end
    @fridge.body_keywords_array.each do |keyword|
      flunk if keyword =~ /^A-Za-z0-9\s/
    end
    assert true
  end
  
  should 'strip out helper verbs and article adjectives from the about keywords' do
    MongoMapper::Plugins::Clortho::ExclusionConstants::VERBS.each do |v|
      flunk if /v.to_s/ =~ @colonial.about_keywords
      flunk if /v.to_s/ =~ @fridge.about_keywords
    end
    assert true
  end
  
  should 'allow searching for multiple keywords' do
    assert_equal Post.search_body_keywords_for('ipsum', 'sit').count, 2
    assert_equal Post.search_about_keywords_for('ipsum', 'sit').count, 0
    assert_equal Post.search_title_keywords_for('refrigerator', 'Colonial').count, 2
  end
  
  should 'allow case-insensitive searching for keywords' do
    assert_equal Post.search_title_keywords_for('ReFrIgErAtOr', 'ColoniaL').count, 2
    assert_equal Post.search_about_keywords_for('IpSuM', 'SIT').count, 0
    assert_equal Post.search_body_keywords_for('ipsUM', 'sIT').count, 2
  end
  
  should 'strip out -- from between two words (i.e., word--again)' do
    assert @fridge.body_keywords !=~ /\-\-/
    assert @colonial.body_keywords !=~ /\-\-/
  end
  
  def teardown
    Post.destroy_all
  end
  
  private
  def save_posts
    @posts.each{ |post| post.save }
  end
end