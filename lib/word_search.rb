class WordSearch
  def search_result(words)
    words.map do |word|
      "#{word[1].upcase} is #{include_word?(word[1])} known word"
    end.join(",\n")
  end

  def include_word?(word)
    words = File.read("/usr/share/dict/words")
    return "a" if words.include?(word.downcase)
    "not a"
  end
end
