function Board() {
  this.grid = []
  for (var i = 0; i < 9; i++)
    this.grid.push(' ')
  
}

Board.prototype = {
  filled: function() {
    return this.grid.every(function(el) { return el !== ' ' })
  },
  
  won: function(mark) {
    var all, row, col, i
    for (row = 0; row < 3; row++) {
      all = true
      for (col = 0; col < 3; col++) {
        if (this.grid[row * 3 + col] !== mark) {
          all = false
          break
        }
      }
      if (all)
        return true
    }
    
    // Test columns
    for (col = 0; col < 3; col++) {
      all = true
      for (row = 0; row < 3; row++) {
        if (this.grid[row * 3 + col] !== mark) {
          all = false
          break
        }
      }
      if (all)
        return true
    }
    
    // (i,i) diagonal
    all = true
    for (i = 0; i < 3; i++) {
      if (this.grid[i * 3 + i] !== mark) {
        all = false
        break
      }
    }
    if (all)
      return true
    
    // (2-i, i) diagonal
    all = true
    for (i = 0; i < 3; i++) {
      if (this.grid[(2-i) * 3 + i] !== mark) {
        all = false
        break
      }
    }
    if (all)
      return true
    
    return false
  },
  
  draw: function() {
    return this.filled() && this.winner() === undefined
  },
  
  winner: function() {
    return this.won('X') ? 'X' : this.won('O') ? 'O' : undefined
  },
  
  game_over: function() {
    return this.filled() || this.winner() !== undefined
  },
  
  get: function(row, col) {
    return (row < 0 || col < 0 || row > 2 || col > 2) ?
      undefined : 
      this.grid[row * 3 + col]
  },
  
  place: function(row, col, mark) {
    if ((mark !== 'X' && mark !== 'O') || this.get(row,col) !== ' ')
      return false
    
    this.grid[row * 3 + col] = mark
    return true
  },
  
  toString: function() {
    string = ""
    for (var row = 0; row < 3; row++) {
      if (row != 0) {
        for (var col = 0; col < 6; col++) {
          string += '-'
        }
      }
      string += "\n"
      for (var col = 0; col < 3; col++) {
        if (col != 0)
          string += '|'
        string += this.grid[row * 3 + col]
      }
      string += "\n"
    }
    return string
  }
}

module.exports = Board
