describe('Hand', function(){

  describe('#sortCards', function(){
    beforeEach(function(){
      this.hand = new Hand([
        new Card('hearts', '7'),
        new Card('clubs', 'A'),
        new Card('diamonds', '3'),
        new Card('hearts', '3'),
        new Card('spades', 'J')
      ]);
    });

    it('sorts cards by rank and suite', function(){
      var sortedCards = [
        new Card('hearts', '3'),
        new Card('diamonds', '3'),
        new Card('hearts', '7'),
        new Card('spades', 'J'),
        new Card('clubs', 'A')
      ];
      expect(this.hand.sortCards()).toEqual(sortedCards);
    });
  });

  describe('#compare', function(){
    beforeEach(function(){
      this.lowHand = new Hand([
        new Card('hearts', '3'),
        new Card('diamonds', '3'),
        new Card('clubs', '3'),
        new Card('hearts', '4'),
        new Card('hearts', '5')
      ]);
      this.highHand = new Hand([
        new Card('hearts', '3'),
        new Card('diamonds', '3'),
        new Card('clubs', '3'),
        new Card('spades', '3'),
        new Card('hearts', '5')
      ]);
    });

    describe('with an equal hand', function(){
      it('returns null', function(){
        expect(this.lowHand.compare(this.lowHand)).toBe(null);
        expect(this.highHand.compare(this.highHand)).toBe(null);
      });
    });

    describe('when passed a weaker hand', function(){
      it('returns the initial hand', function(){
        expect(this.highHand.compare(this.lowHand)).toBe(this.highHand);
      });
    });

    describe('when passed a stronger hand', function(){
      it('returns the passed hand', function(){
        expect(this.lowHand.compare(this.highHand)).toBe(this.highHand);
      });
    });
  });

  describe('#valid', function(){
    describe('with 5 valid cards', function(){

      beforeEach(function(){
        var validCards = [
          new Card('heart', '10'),
          new Card('heart', 'J'),
          new Card('heart', 'Q'),
          new Card('heart', 'K'),
          new Card('heart', 'A')
        ];
        this.hand = new Hand(validCards);
      });

      it('returns true', function(){
        expect(this.hand.valid()).toBe(true);
      });
    });

    describe('with 4 cards', function(){
      beforeEach(function(){
        var invalidCards = [
          new Card('heart', '10'),
          new Card('heart', 'J'),
          new Card('heart', 'Q'),
          new Card('heart', 'K')
        ];
        this.hand = new Hand(invalidCards);
      });

      it('returns false', function(){
        expect(this.hand.valid()).toBe(false);
      });
    });
  });
});
