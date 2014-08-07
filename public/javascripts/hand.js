function Hand(cards) {
  this.valid = function() {
    if(5 != cards.length)
      return false;
    _(cards).each(function(card){
      if (!card.valid()) {
        return false;
      }
    });
    return true;
  };

  this.sortCards = function(){
    return cards;
  };

  this.value = function() {
    var handRank = 0;
    var cardRank = 0;
    var suite = 0;

    return (10000 * handRank) + (100 * cardRank) + suite;
  };

  this.compare = function(otherHand){
    if (this.value() > otherHand.value()) {
      return this;
    } else if (otherHand.value() > this.value()) {
      return otherHand;
    } else {
      return null;
    }
  };
}









// ranking: flush
//no ranking - 0
//one pair - 1
//two pair - 2
//Three of a kind = 3
// Straigh

// number: 2-A
// suite: spades, clubs, diamonds, hearts
// [4, 5, 0];
