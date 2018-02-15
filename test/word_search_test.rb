require 'minitest/autorun'
require 'minitest/pride'
require './lib/word_search'

class WordSearchTest < Minitest::Test

  def test_it_exists
    word = WordSearch.new

    assert_instance_of WordSearch, word
  end

  def test_it_can_search_dictionary
    word = WordSearch.new
    words = [["word", "hello"]]
    expected = "HELLO is a known word"

    assert_equal expected, word.search_result(words)
  end

  def test_it_can_search_dictionary_for_multiple_words
    word = WordSearch.new
    words = [["word", "hello"], ["word2", "programmin"]]
    expected = "HELLO is a known word,\nPROGRAMMIN is not a known word"

    assert_equal expected, word.search_result(words)
  end

  def test_it_can_return_a_or_not_a
    word = WordSearch.new

    assert_equal "a", word.include_word?("hello")
    assert_equal "not a", word.include_word?("programmin")
  end
end
