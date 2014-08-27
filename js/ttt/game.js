var Board = require('./board'), readline = require('readline')

function Game(reader) {
  this.reader = reader
  this.player = 'X'
  this.board = new Board()
}

Game.prototype = {
  promptMove: function(callback) {
    var that = this
    
    console.log(this.board.toString())
    
    this.reader.question(  'row?    : ', function(row) {
      that.reader.question('column? : ', function(col) {
        callback(parseInt(row),parseInt(col))
      })
    })
  },
  
  run: function(completionCallback) {
    var that = this
    
    console.log(this.board.game_over())
    
    if (this.board.game_over())
      completionCallback()
    else {
      this.promptMove(function(row, col) {
        if (that.board.place(row,col,that.player))
          that.swap()
        else
          console.log('invalid move -- try again')
        
        that.run(completionCallback)
      })
    }
  },
  
  play: function() {
    var that = this
    this.run(function() {
      that.swap()
      console.log('Game over!')
      if (that.board.draw()) {
        console.log('Nobody won...')
      } else {
        console.log('The winner was: ' + that.player)
      }
      that.reader.close()
    })
  },
  
  swap: function() {
    this.player = (this.player === 'X') ? 'O' : 'X'
  }
}

if (require.main === module) {
  // I would preferred to have the Game class create the reader,
  // as it must also take care of destroying it.
  // But the instructions suggest to pass reader to constructor.
  var reader = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  })
  new Game(reader).play()
}
