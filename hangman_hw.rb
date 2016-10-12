# A version of hangman that's playable in the terminal
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
    num_guesses = num_unique_chars(word)+15
  when "medium"
    num_guesses = num_unique_chars(word)+9
  when "hard"
    num_guesses = num_unique_chars(word)+6
  end
  return num_guesses
end

# pick a random item from an array
def rand_item(array)
  rand_index = rand(array.length)
  return array[rand_index]
end


# output an appropriate gameboard based on what the user has guessed
def update_game_board(game_word, guess_char_array)
  new_board = ""
  game_word_array = game_word.chars.to_a
  game_word_array.each do |char|
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

# check if the player won the game
def did_you_win?(game_word, guess_char_array)
  game_word_array = mk_string_array(game_word.downcase).uniq
  return game_word_array&guess_char_array.uniq == game_word_array
end

# gets a guess from the user and adds it to the guess_array
hangman_words = ["the iron yard"]
game_mode = "easy"
all_guesses = []
game_word = rand_item(hangman_words)
remaining_guesses = how_many_guesses(game_word, game_mode)
puts "Welcome to Hangman! Please guess a valid character"
update_game_board(game_word, [])
won = false

until remaining_guesses == 0 || won == true
  guess_character = (gets.chomp).downcase
  all_guesses << guess_character
  update_game_board(game_word, all_guesses)
  remaining_guesses -= 1
  won = did_you_win?(game_word, all_guesses)
end
