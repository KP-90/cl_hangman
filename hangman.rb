require 'json'
def alpha?(char)
    char.upcase == char.downcase
end

MAX_TURNS = 10

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
    end

    def draw()
        #If the guessed letters are empty, create an array of just '_'
        if @letters == ""
            @display
        else
            @display = @word.tr('^' + @letters, '_').chars.join(' ')
        end
        p @display
        puts
    end

    def get_choice()
        choice = gets.chomp.downcase
        save_game(self) if choice.downcase == 'save'
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
        #Output to the user: Letters they've guessed, and how many they've got wrong.
        p @letters.chars.sort.join("-")
        p "#{@wrong.length}/#{MAX_TURNS} wrong"
    end

    def save_game(class_instance)
        puts "saving game"
        sleep(1)
        serial = Marshal.dump(class_instance)
        File.write("savefile.sav", serial)
        puts "Game Saved!"
        sleep(1)
        puts "Goodbye!"
        exit
    end

    def play_game
        puts "Guess the word. You are only allowed #{MAX_TURNS} wrong guesses."
        self.draw
        #Output to the user: Letters they've guessed, and how many they've got wrong.
        p @letters.chars.sort.join("-")
        p "#{@wrong.length}/#{MAX_TURNS} wrong"
        
        loop do
            self.get_choice
            #Check for any instances of "_". If there arent any, then all the letters have been guessed
            if !self.display.include?("_")
                File.delete('savefile.sav') if File.exist?('savefile.sav')
                puts "CONGRATULATIONS!!! YOU WON"
                puts "and you only guessed #{self.turns} wrong letters"
                puts
                puts
                break
            end
            if self.turns >= MAX_TURNS
                File.delete('savefile.sav') if File.exist?('savefile.sav')
                puts "Sorry, you lose."
                puts "The word was #{self.word}"
                puts
                puts
                break
            end
        end
    end
end


puts "Do you want to start a new game or continue from a save file?\n1. New Game\n2. Continue"
input = gets.chomp
loop do
    if input == '2' && !File.exist?('savefile.sav')
        puts 'Sorry, no save file was detected! Please start a new game.'
        puts "Do you want to start a new game or continue from a save file?\n1. New Game\n2. Continue"
        input = gets.chomp
        next
    end
    break if input == "1" || input == '2'
    puts 'Please select either 1 or 2'
    input = gets.chomp
end
game = if input == "1"
    Hangman.new()
else
    Marshal.load(File.read('savefile.sav'))
end
system("clear")
game.play_game