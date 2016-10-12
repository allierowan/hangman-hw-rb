# A version of hangman that's playable in the terminal

# array of possible words that we can play with
hangman_words = ["the iron yard"]
game_mode = "easy"
all_guesses = []
#game_word = rand_item(hangman_words)

# puts all characters (except the space) of a word into an array
def mk_string_array(word)
  return (word.gsub(" ", "")).chars.to_a
end

# how many unique characters in a string, ignoring spaces
def num_unique_chars(word)
  char_array = (mk_string_array(word.downcase)).uniq
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
def put_game_board(game_word)
  word_string = ""
  char_array = game_word.chars.to_a
  char_array.each do |char|
    if char == " "
      word_string += "  "
    else
      word_string += "_ "
    end
  end
  puts word_string
end

# update the game board based on a guess
def update_game_board(game_word, guess_char_array)
  new_board = ""
  game_word_array = game_word.chars.to_a
  game_word_array.each do |char|
    p char
    if guess_char_array.index(char.downcase)
      new_board += char + " "
    elsif char == " "
      new_board += "  "
    else
      new_board += "_ "
    end
  end
  puts new_board
end
