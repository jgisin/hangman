require 'sinatra'
require 'sinatra/reloader'

word_length = ['_', '_', '_', '_']
dictionary = File.open("enable.txt", "r")
contents = dictionary.read

get '/' do
	if params["guess"] != nil
		word_length[0] = params["guess"]
	end
	erb :index, :locals => {:word_length => word_length,
	:contents => contents}
end