require 'sinatra'
require 'dm-core'

DataMapper::setup(:default, {:adapter => 'yaml', :path => 'db'})

class Card
	include DataMapper::Resource
	
	property :id, Serial
	property :name, String
	property :value, Integer
	property :suit, String
end

#create temporary route to upload card data into database
get '/setDatabase' do

	suitArray = ["diamonds", "hearts", "clubs", "spades"]
	cardArray = ["2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"]
	
	##for loop to create some object with suit of suitArray[suit] and name of cardArray[name]
	output = ""
	suitArray.each do |suit|
		cardArray.each do |name|
			i = 0
			card = Card.new
			card.suit = suit
			card.name = name
			card.value = i+2
			card.save
			i = i+1
			output += "you have created a #{card.name} of #{card.suit}<br/>"
		end
	end
	output
end
	
	
		