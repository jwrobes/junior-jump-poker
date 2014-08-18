require 'pry'

suits = ["hearts", "diamonds", "clubs", "spades"]

ranks = %w(2 3 4 5 6 7 8 9 10 J Q K A)

class Card 

	attr_reader :suit, :rank
	
	def initialize(rank, suit)
		@suit = suit
		@rank = set_numeric_rank(rank)
		@suits = ["hearts", "diamonds", "clubs", "spades"]
		@ranks = (1..14).to_a
	end

	def is_valid?
		@suits.include?(@suit) && @ranks.include?(@rank)
	end

	private

	def set_numeric_rank(rank)
		case rank
			when "A"
				return 14
			when "K"
				return 13
			when "Q"
				return 12
			when "J"
				return 11
			else 
				return rank.to_i	
		end		
	end

end

class ConvertStringToCardsArray
	
	def initialize 
		@suits_key = {'H' => "hearts", 'D' => "diamonds", 'C' => "clubs", 'S' => "spades"}
		end

	def execute(cards)
		array_of_card_strings = parse_string(cards)
		array_cards = build_cards(array_of_card_strings)
		check_if_cards_valid(array_cards)
		return array_cards
	end

	private

	def parse_string(cards)
		cards.split(' ')
	end  	

	def build_cards(array_of_card_strings)
		cards = []
		array_of_card_strings.each do |card|
			suit = card.slice!(-1)
			suit_name = @suits_key[suit]
			rank = card
			cards << Card.new(rank, suit_name)
		end
		cards
	end	

	def check_if_cards_valid(array_cards)
		number_of_valid_cards = array_cards.count { |card| card.is_valid? }
		if number_of_valid_cards < array_cards.count
			raise StandardError.new("Not in valid format")
		end	
	end

end

class Hand

	attr_reader :cards, :suits, :ranks, :kickers, :name

	def initialize(cards)
		@cards = cards
		@suits = grab_suits(cards)
		@ranks = grab_ranks(cards)
		@duplicate_cards = build_duplicate_cards_hash(@ranks)
		@name = name_hand
		@kickers = set_kickers
		@hand_key = {"Straight Flush" => 9, "Four of a Kind" => 8, "Full House" => 7, "Flush"=> 6, "Straight"=> 5, "Three of a Kind"=>4, "Two Pair"=>3, "pair"=>2, "High Card"=>1}
	end

	def higher_hand?(hand)
		if @hand_key[@name] > @hand_key[hand.name]
			return true
		elsif  @hand_key[@name] < @hand_key[hand.name]
			return false
		else
			return 	compare_kickers(hand.kickers)
		end			
	end	

	private

	def name_hand
		if is_straight? && is_flush?
			return "Straight Flush"
		elsif is_straight?	
			return "Straight"
		elsif is_flush?
			return "Flush"
		elsif is_full_house?
			return "Full House"
		elsif is_two_pair?
			return "Two Pair"
		elsif is_four_of_a_kind?
			return "Four of a Kind"
		elsif is_pair?
			return "pair"
		elsif is_three_of_kind?
			return "Three of a Kind"
		elsif is_high_card?
			return "High Card"
		end
	
	end

# set up hand

	def grab_ranks(cards)
		cards.map {|card| card.rank}
	end

	def return_ranks_for_straight(ranks)
		if has_two?(ranks)
			ranks_for_straight = convert_ace(@ranks)
		else
			ranks_for_straight = @ranks
		end	
	end

	def has_two?(ranks)
		ranks.include?(2)
	end

	def convert_ace(ranks)
		ranks.map{|rank| rank == 14 ? 1 : rank }
	end

	def grab_suits(cards)
		cards.map {|card| card.suit}
	end

	def build_duplicate_cards_hash(ranks)
		full_hash =	Hash.new(0)
		@ranks.each do |rank|
			full_hash[rank] += 1
		end
		full_hash.delete_if {|k,v| v < 2}
	end

	
	def is_four_of_a_kind?
		@duplicate_cards.count == 1 && @duplicate_cards.values.max == 4
	end
	
	def is_full_house?
		@duplicate_cards.count == 2 && @duplicate_cards.values.max == 3
	end

	def is_flush?
		@suits.uniq.length == 1
	end

	def is_straight?
		ranks_for_straight = return_ranks_for_straight(@ranks)
		ranks_for_straight.sort!
		count_in_order = 0
		4.times do |i|
			if ranks_for_straight[i] + 1 == ranks_for_straight[i+1]
				count_in_order += 1
			end
		end
		count_in_order == 4
	end

	def is_three_of_kind?
		@duplicate_cards.count ==1 && @duplicate_cards.values.max == 3
	end

	def is_two_pair?
			@duplicate_cards.count == 2 && @duplicate_cards.values.max == 2
	end

	def is_pair?
		@duplicate_cards.count == 1 && @duplicate_cards.values.max == 2
	end

	def is_high_card?
		@duplicate_cards.count == 0
	end

	def get_non_duplicate_ranks
		non_dups = @ranks.select do |rank|
			not_in_duplicates_hash?(rank)
		end
		non_dups.sort.reverse
	end

	def not_in_duplicates_hash?(rank)
		@duplicate_cards[rank] < 2
	end

	# get values of non kickers for all hands

	def get_four_of_kind_value
		@duplicate_cards.key(4)
	end

	def get_full_house_values
		[@duplicate_cards.key(3), @duplicate_cards.key(2)]
	end
	
	def get_three_of_kind_value
		@duplicate_cards.key(3)
	end

	def get_two_pair_values
		pairs = []
		@duplicate_cards.each {|k,v| pairs << k}
		pairs.sort.reverse
	end

	def get_pair_value
		@duplicate_cards.key(2)
	end

	def set_kickers
		if is_straight?
			return [return_ranks_for_straight(@ranks).max]
		elsif is_flush? || is_high_card?
			return @ranks.sort.reverse
		elsif is_pair?
			return get_non_duplicate_ranks.unshift(get_pair_value)
		elsif is_two_pair?
			return get_two_pair_values + get_non_duplicate_ranks
		elsif is_three_of_kind?
			return get_non_duplicate_ranks.unshift(get_three_of_kind_value)
		elsif is_four_of_a_kind?
			return get_non_duplicate_ranks.unshift(get_four_of_kind_value)
		elsif is_full_house?
			return get_full_house_values + get_non_duplicate_ranks
		end
	end

	def compare_kickers(other_kickers)
		@kickers.each_with_index do |kicker, i|
			return false if kicker < other_kickers[i]
		end
		true
	end

end