require './poker.rb'

RSpec.describe Card do
	describe '#suit' do
		it "should return suit" do
			card = Card.new("2","hearts")
			expect(card.suit).to eq("hearts")
		end
		it "should return a rank of 11 if its Jack" do
			jack = Card.new("J", "hearts")
			expect(jack.rank).to eq(11)
		end
		it "should return a rank of 12 if its a Queen" do
			jack = Card.new("Q", "hearts")
			expect(jack.rank).to eq(12)
		end
	end
	describe "#is_valid?" do
		it "should return true if card is valid" do
			valid_card = Card.new("2","hearts")
			(valid_card.is_valid?).should == true
		end
		it "should return false if card has invalid rank" do
			valid_card = Card.new("16","diamonds")
			(valid_card.is_valid?).should == false
		end
		it "should return false if card has invalid suit" do
			valid_card = Card.new("7","horses")
			(valid_card.is_valid?).should == false
		end
		it "should return false if card has invalid rank and suit" do
			valid_card = Card.new("1","horses")
			(valid_card.is_valid?).should == false
		end
		it "a card return a rank of 11 if its Jack" do
			jack = Card.new("J", "hearts")
			expect(jack.rank).to eq(11)
		end
	end
end



RSpec.describe ConvertStringToCardsArray do
	describe 'build cards array' do
		it "should return array of card objects out of string in valid format" do
			converter = ConvertStringToCardsArray.new
			cards = converter.execute("8H QD 8S JH 8D")
			cards_count = cards.count { |card| card.is_valid? }
			expect(cards_count).to eq (5)
		end
		it "returns error if string is not in valid format" do
			expect{ConvertStringToCardsArray.new.execute("17H QF 8S JH 8D")}.to raise_error
		end
	end
end 

RSpec.describe Hand do
	describe '#cards' do
		it "should have five cards" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S JH 8D")
			hand = Hand.new(cards)
			expect(hand.cards.length).to eq(5) 
		end
	end
	describe '#suits' do
		it "should have only suits" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S JH 8D")
			hand = Hand.new(cards)
			expect(hand.suits.uniq).to eq(['hearts','diamonds','spades']) 
		end
	end
	describe '#ranks' do
		it "should have only all the ranks" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S JH 8D")
			hand = Hand.new(cards)
			expect(hand.ranks).to eq([8,12,8,11,8].sort!) 
		end	
	end

	describe "#name"	do
		it "should return straight hand name" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 10S JH 9D")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Straight")
		end
		it "should return straight hand name with A" do
			cards = ConvertStringToCardsArray.new.execute("4H 3D 2S AH 5D")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Straight")
		end
		it "should return pair hand name" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S JH 9D")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("pair")
		end
		it "should return fullhouse hand name" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S QH QD")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Full House")
		end
		it "should return three of a kind hand name" do
			cards = ConvertStringToCardsArray.new.execute("4H QD 8S QH QD")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Three of a Kind")
		end
		it "should return four of a kind hand name" do
			cards = ConvertStringToCardsArray.new.execute("8H 8D QS 8C 8S")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Four of a Kind")
		end
		it "should return fullhouse hand name" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S QH JD")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Two Pair")
		end
		it "should return flush hand name" do
			cards = ConvertStringToCardsArray.new.execute("8H 7H AH QH 3H")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Flush")
		end
		it "should return straight flush hand name" do
			cards = ConvertStringToCardsArray.new.execute("8H 7H 9H 10H JH")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("Straight Flush")
		end
		it "should return High Card" do
			cards = ConvertStringToCardsArray.new.execute("8H 2H 9H 10D JH")
			hand_name = Hand.new(cards).name
			expect(hand_name).to eq("High Card")
		end
	end

	describe "#kickers" do
		it "should return one kicker for a straight" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 10S JH 9D")
			expect(Hand.new(cards).kickers).to eq([12])
		end	
		it "should return five as kicker for straight with A to 5" do
			cards = ConvertStringToCardsArray.new.execute("AH 2D 3S 4H 5D")
			expect(Hand.new(cards).kickers).to eq([5])
		end	
		it "should return all ranks in reverse order for a flush" do
			cards = ConvertStringToCardsArray.new.execute("8H 7H AH QH 3H")
		end
		it "should return pair value and then remaining cards in descending order for kickers" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S JH 9D")
			expect(Hand.new(cards).kickers).to eq([8,12,11,9])
		end	
		it "should return highest pair, second highest pair and kicker in kickers for two pair" do
			cards = ConvertStringToCardsArray.new.execute("8H QD 8S QH JD")
			expect(Hand.new(cards).kickers).to eq([12,8,11])
		end	
		it "should four of a kind value and remaining card in kickers" do
			cards = ConvertStringToCardsArray.new.execute("8H 8D QS 8C 8S")
			expect(Hand.new(cards).kickers).to eq([8,12])
		end		
		it "should three of a kind value and two remaining cards in descending order in kickers" do
			cards = ConvertStringToCardsArray.new.execute("4H QD KS QH QD")
			expect(Hand.new(cards).kickers).to eq([12,13,4])
		end		
		it "should three of a kind value and two of kind value in kickers" do
			cards = ConvertStringToCardsArray.new.execute("KH QD KS QH QS")
			expect(Hand.new(cards).kickers).to eq([12,13])
		end		
	end
	describe "#higher_hand?" do
		it "should return true if compared to a lower hand (Full House vs Three of a KInd" do
			cards1 = ConvertStringToCardsArray.new.execute("KH QD KS QH QS")
			cards2 = ConvertStringToCardsArray.new.execute("4H QD KS QH QD")
			h1 = Hand.new(cards1)
			h2 = Hand.new(cards2)
			expect(h1.higher_hand?(h2)).to eq(true)
		end
		it "should return true if higher than hand compared to it (High Card vs High Card" do
			cards1 = ConvertStringToCardsArray.new.execute("AH QD 10S 8H 4S")
			cards2 = ConvertStringToCardsArray.new.execute("AH JD 10S 3H 2D")
			h1 = Hand.new(cards1)
			h2 = Hand.new(cards2)
			expect(h1.higher_hand?(h2)).to eq(true)
		end
		it "should return true if higher than hand compared to it (Pair vs Pair)" do
			cards1 = ConvertStringToCardsArray.new.execute("KH KD 10S 8H 4S")
			cards2 = ConvertStringToCardsArray.new.execute("KH KD 9S 3H 2D")
			h1 = Hand.new(cards1)
			h2 = Hand.new(cards2)
			expect(h1.higher_hand?(h2)).to eq(true)
		end
		it "should return true if compared to a flush with one card lower" do
			cards1 = ConvertStringToCardsArray.new.execute("KD QD 10D 8D 3D")
			cards2 = ConvertStringToCardsArray.new.execute("KH QH 10H 8H 2H")
			h1 = Hand.new(cards1)
			h2 = Hand.new(cards2)
			expect(h1.higher_hand?(h2)).to eq(true)
		end
	end	
end
