def alpha?(char)
    char.upcase == char.downcase
end

MAX_TURNS = 7

class Hangman

    attr_reader :turns, :word, :display

    def initialize()
        @turns = 0
        @letters = ""
        @display = ""
        @wrong = ""
        contents = File.readlines("valid_words.txt")
        #Pick a random word from the file
        @word = contents[rand(0..contents.length - 1)]
        #Get rid of the newline character
        @word = word.strip
        @display = Array.new(@word.length, "_").join(" ")

        puts "There are #{@word.length} letters in this word"
    end

    def draw()
        #If the guessed leters are empty, create an array of just '_'
        if @letters == ""
            @display = Array.new(@word.length, "_").join(" ")
        else
            @display = @word.tr('^' + @letters, '_').chars.join(' ')
        end
        p @display
        puts
    end

    def get_choice()
        choice = gets.chomp.downcase
        while choice.length != 1 || alpha?(choice) || @letters.include?(choice) do
            if @letters.include?(choice)
                puts "You already guessed that letter"
            else
                puts "Error, please enter only one letter"
            end
            choice = gets.chomp.downcase
        end
        # Only increase turns when they get a letter wrong
        if !@word.include?(choice)
            @wrong.concat("X")
            @turns += 1
        end
        @letters.concat(choice)
        system("clear")
        self.draw
        p @letters.chars.sort.join("-")
        p "#{@wrong.length}/#{MAX_TURNS} wrong"
    end
end

def play_game()
    x = Hangman.new()
    puts "Guess the word. You are only allowed #{MAX_TURNS} wrong guesses."
    loop do
        x.get_choice
        if !x.display.include?("_")
            puts "CONGRATULATIONS!!! YOU WON"
            puts "and you only guessed #{x.turns} wrong letters"
            puts
            puts
            break
        end
        if x.turns >= MAX_TURNS
            puts "Sorry, you lose."
            puts "The word was #{x.word}"
            puts
            puts
            break
        end
    end
end

system("clear")
play_game()