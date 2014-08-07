var suites = ['hearts', 'clubs', 'dimonds', 'spades'];
var ranks = ['2','3','4','5','6','7','8','9','10','J','Q','K','A'];

function Card (suite, rank){
  var foo = 'bar';
  this.suite = suite;
  this.rank = rank;

  this.valid = function (){
    return _(suites).contains(suite) && _(ranks).contains(rank);
  };
}
