# A version of hangman that's playable in the terminal

# array of possible words that we can play with
hangman_words = ["the iron yard"]

# how many unique characters in a string
def unique_chars(word)
  char_array = word.chars.to_a.uniq
  char_array.length
end

# how many guesses will the user get, which is based on how many unique letters are in the word
def num_guesses(word)
  
end
