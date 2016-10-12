# A version of hangman that's playable in the terminal

# array of possible words that we can play with
hangman_words = ["the iron yard"]
game_mode = "easy"

# how many unique characters in a string
def unique_chars(word)
  no_spaces = word.sub(" ", "")
  char_array = no_spaces.downcase.chars.to_a.uniq
  char_array.length
end

# how many guesses will the user get, which is based on how many unique letters are in the word
def how_many_guesses(word, mode = "easy")
  case mode
  when "easy"
    num_guesses = unique_chars(word)+15
  when "medium"
    num_guesses = unique_chars(word)+9
  when "hard"
    num_guesses = unique_chars(word)+6
  end
  return num_guesses
end

# pick a random item from an array
def rand_item(array)
  rand_index = rand(array.length)
  return array[rand_index]
end

# output the game board
def put_game_board(random_word)
  word_string = ""
  char_array = random_word.chars.to_a
  char_array.each do |char|
    if char == " "
      word_string += "  "
    else
      word_string += "_ "
    end
  end
  puts word_string
end
