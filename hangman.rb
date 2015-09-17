require 'sinatra'
#require 'sinatra/reloader'

word_length = ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']
arr = []
random_num = rand(arr.length)
contents = ""
counter = 0

get '/' do
	counter = 0
	contents = ""
	query = params.map{|key, value| "#{key}=#{value}"}.join("&")
		if params["difficulty"] != nil
			redirect("game?#{query}")
		end
		query = params.map{|key, value| "#{key}=#{value}"}.join("&")
		


	erb :index, :locals => {:word_length => word_length,
	:contents => contents}

end

get '/game' do

	if contents == ""
			dictionary = File.open("enable.txt", "r")
		
			while !dictionary.eof?
				line = dictionary.readline
					if line.length - 1 == params["difficulty"].to_i
						arr << line
					end
			end
			contents = arr.join.split("\n")[rand(arr.length)].to_s
				if contents != ""
					word_length = word_length.take(contents.length)
				end
			dictionary.close
	end
		if params["guess"] != nil && counter < word_length.length
			word_length[counter] = params["guess"]
			counter += 1
		end

	erb :game, :locals => {:word_length => word_length,
		:contents => contents}

end



