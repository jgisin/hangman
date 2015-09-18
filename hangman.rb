require 'sinatra'
#require 'sinatra/reloader'

#Initialize Variables
word_length = ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']
arr = []
contents = ""
counter = 0
message = "Wrong guesses: #{counter}"
guessed = []

#root/index route and control
get '/' do

		#Reset variables on index reload for new game
	word_length = ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']
	arr = []
	contents = ""
	counter = 0
	message = "Wrong guesses: #{counter}"
	guessed = []

	#Passes the difficulty param into the redirect for use in game.erb
	query = params.map{|key, value| "#{key}=#{value}"}.join("&")
		if params["difficulty"] != nil
			redirect("game?#{query}")
		end
		
	erb :index, :locals => {:word_length => word_length,
	:contents => contents}

end



#Game.erb route and control
get '/game' do
	#If statement for first load of game.erb before contents assigned
	if contents == ""
			dictionary = File.open("enable.txt", "r")
		#Reads each line and filters words by length to match difficulty
			while !dictionary.eof?
				line = dictionary.readline
					if line.length - 1 == params["difficulty"].to_i
						arr << line
					end
			end
	#Formats the output to remove \n at end of each word
	#and sets word_length array to length of selected word
			contents = arr.join.split("\n")[rand(arr.length)].to_s
				if contents != ""
					word_length = word_length.take(contents.length)
					dictionary.close
				end
	#After contents assigned and word_length set runs else statement
	else
	#If guess is correct, displays guess in word_length array
		split_word = contents.split(//)
			if split_word.include?(params["guess"])
				split_word.each_with_index do |value, index|
					if split_word[index] == params["guess"]
						word_length[index] = params["guess"]
					end
				end
				
				#Defines win condition
				if word_length.join("") == contents
					message = "You win!"
				end

			#Defines losing condition and maintains counter		
			else
				guessed << params["guess"]
				if counter < 5
					counter += 1
					message = "Wrong guesses: #{counter}"
				else
					counter += 1
					message = "You Lose, the word was #{contents}"
				end
			end

	end
	
	
	erb :game, :locals => {:word_length => word_length,
		:contents => contents, :counter => counter, :message => message,
	:guessed => guessed}

end



