require 'sinatra'
require 'sinatra/reloader'

word_length = ['_', '_', '_', '_', '_', '_', '_', '_', '_', '_']
arr = []
random_num = rand(arr.length)
contents = ""


get '/' do
		if params["difficulty"] != nil
			redirect('game')
			set erb :game
		end
		difficulty = nil
		if params["difficulty"] != nil
			difficulty = params["difficulty"].to_i
		end

	dictionary = File.open("enable.txt", "r")
	
		while !dictionary.eof?
			line = dictionary.readline
				if line.length - 1 == difficulty
					arr << line
				end
		end
		contents = arr.join.split("\n")[rand(arr.length)].to_s
			if params["difficulty"] != nil
				word_length = word_length.take(contents.length)
			end
		dictionary.close

		
		#if params["guess"] != nil
			#word_length[0] = params["guess"]
		#end

	erb :index, :locals => {:word_length => word_length,
	:contents => contents}

end

get '/game' do
	erb :game, :locals => {:word_length => word_length,
	:contents => contents}
end



