// OK, monkey patching is, in general, bad,
// but I can't believe there is no 'peek' method on array...
Array.prototype.peek = function() {
  return this[this.length - 1]
}

/////////

function HanoiGame(N) {
  
  this.N = N
  
  this.discs = [ [], [], [] ]
  
  for (var i = N-1; i >= 0; i--)
    this.discs[0].push(i)
}

HanoiGame.prototype = {
  isWon: function() {
    return this.discs[2].length === this.N
  },
  
  isValidMove: function(from, to) {
    // The move is invalid if
    //   *) there are no discs on the 'from' pile.
    // 
    // Then the move is valid if either 
    //   1) the 'to' pile is empty,
    //      or
    //   2) the top of the 'to' pile is larger than the disc to move.
    // 
    // Also, a more subtle point to note, is that if from === to,
    // isValidMove will always return false.
    // 
    return from >= 0 && from < 3 && to >= 0 && to < 3 &&
      this.discs[from].length > 0 && (
      this.discs[to].length === 0 ||
      this.discs[to].peek() > this.discs[from].peek())
  },
  
  move: function(from, to) {
    if (this.isValidMove(from,to)) {
      this.discs[to].push(this.discs[from].pop())
      return true;
    }
    return false;
  },
  
  /* Console UI stuff */
  
  print: function() {
    console.log(JSON.stringify(this.discs))
  },
  
  promptMove: function(callback) {
    var that = this
    this.print()
    this.reader.question(  'Enter pile to take disc from : ', function(from) {
      that.reader.question('Enter pile to move disc to   : ', function(to) {
        callback(parseInt(from), parseInt(to))
      })
    })
  },
  
  run: function(completionCallback) {
    var that = this
    this.promptMove(function (from, to) {
      if (!that.move(from, to))
        console.log("Invalid move --")
      
      if (that.isWon())
        completionCallback()
      else
        that.run(completionCallback)
    })
  },
  
  play: function() {
    var readline = require('readline'), that = this
    this.reader = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    })
    
    this.run(function () {
      console.log("Yay!! You've won!!")
      that.reader.close()
    })
  }
}

if (require.main === module) {
  var h = new HanoiGame(1)
  h.play()
}
