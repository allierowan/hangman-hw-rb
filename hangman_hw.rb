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

# evaluate a guess as right, wrong, already guessed, invalid, solved, or asking for a hint
def check_guess(game_word, guess_char, already_guessed)
  game_word_array = mk_string_array(game_word.downcase).uniq
  result = ""
  valid_chars = ("a".."z").to_a+("A".."Z").to_a
  if already_guessed.include?(guess_char)
    result = "already guessed"
  elsif game_word_array.include?(guess_char)
    result = "char found"
  elsif guess_char == "exit"
    result = "exit"
  elsif guess_char == "get a hint"
    result = "hint"
  elsif guess_char.start_with?("solve")
    solve_array = guess_char.split(" ")
    solve_array.shift
    guess_string = solve_array*" "
    if guess_string == game_word.downcase
      return "solved"
    else
      return "char not found"
    end
  elsif !valid_chars.include?(guess_char)
    result = "invalid char"
  else
    result = "char not found"
  end
end
file_words = File.readlines("/usr/share/dict/words")
hangman_words = []
file_words.each do |word|
  if word[0].upcase != word[0]
    hangman_words.push(word.chomp)
  end
end
# gets a guess from the user and adds it to the guess_array
play_again = true
until play_again == false
  all_guesses = []
  game_word = rand_item(hangman_words)
  mode_options = ["easy", "medium", "hard"]
  puts "Welcome to Hangman!"
  puts "What mode would you like to play in? Easy, Medium, or Hard?"
  game_mode = gets.chomp.downcase
  if !mode_options.include?(game_mode)
    game_mode = rand_item(mode_options)
    puts "Fine, I'll pick for you. You're playing in #{game_mode} mode."
  end
  remaining_guesses = how_many_guesses(game_word, game_mode)
  puts "Since this is #{game_mode} mode, you get #{remaining_guesses} guesses. Please guess a valid character, or type exit to leave"
  puts "You may attempt to guess the full word by typing 'solve' and then your guess."
  puts "If you need a hint as to which of the 26 letters you should guess, please type 'get a hint'"
  update_game_board(game_word, [])
  over = false
  num_hints = 4
  until remaining_guesses == 0 || over == true
    guess_character = (gets.chomp).downcase
    case check_guess(game_word, guess_character, all_guesses)
    when "already guessed"
      puts "Way to go, you already guessed #{guess_character}."
      puts "You have #{remaining_guesses} guesses remaining. So far, you have guessed #{all_guesses}"
    when "char found"
      all_guesses << guess_character
      if did_you_win?(game_word, all_guesses)
        over = true
        puts "#{game_word}"
        puts "Good job, you won this game, which is for children."
      else
        puts "Only 26 letters in the alphabet, you were bound to guess correctly sometime."
        puts "You have #{remaining_guesses} guesses remaining. So far, you have guessed #{all_guesses}"
      end
    when "char not found"
      remaining_guesses -= 1
      all_guesses << guess_character
      if remaining_guesses == 0
        over = true
        puts "Welp, you lost a children's game. The word was #{game_word}."
      else
        puts "Nope, guess again bozo."
        puts "You have #{remaining_guesses} guesses remaining. So far, you have guessed #{all_guesses}"
      end
    when "hint"
      unguessed_chars = mk_string_array(game_word.downcase).uniq - all_guesses
      hint = rand_item(unguessed_chars)
      num_hints -= 1
      if num_hints == 0
        puts "Sorry, Charlie. No more hints"
      else
        puts "If you must. Try #{hint}. You have #{num_hints-1} hints remaining"
      end
    when "exit"
      over = true
      puts "Cool, see ya later bro."
    when "invalid char"
      puts "#{guess_character} is not a character. Be grateful I don't take away one of your #{remaining_guesses} guesses for that b.s."
      puts "So far, you have guessed #{all_guesses}"
    when "solved"
      over = true
      puts "#{game_word}"
      puts "Good job, you won this game, which is for children."
    end
    if over == false
      update_game_board(game_word, all_guesses)
    end
  end
  puts "Would you like to play again? If so, respond with 'Y'"
  user_response = gets.chomp.downcase
  if user_response == "y"
    play_again = true
  else
    play_again = false
  end
end
