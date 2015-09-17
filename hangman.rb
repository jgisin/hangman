require 'sinatra'
#require 'sinatra/reloader'

#Initialize Variables
word_length = ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']
arr = []
contents = ""
counter = 0

#root/index route and control
get '/' do
	#Reset variables on index reload for new game
	counter = 0
	contents = ""
	word_length = ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']

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
	#Pick the word from the dictionary based on difficulty
	if contents == ""
			dictionary = File.open("enable.txt", "r")
		
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
	else
	#Assigns guess param to target location in word_length array
		split_word = contents.split(//)
			if split_word.include?(params["guess"])
				split_word.each_with_index do |value, index|
					if split_word[index] == params["guess"]
						word_length[index] = params["guess"]
					end
				end
			else
				if counter < 5
					counter += 1
				else
					counter = "You Lose"
				end
			end

	end
	
	
	#Iterates through the arr, this is temporary only
		#if params["guess"] != nil && counter < word_length.length
			#word_length[counter] = params["guess"]
			#counter += 1
		#end

	erb :game, :locals => {:word_length => word_length,
		:contents => contents, :counter => counter}

end



