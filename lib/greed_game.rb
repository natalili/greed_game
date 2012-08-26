require "greed_game/version"
require "greed_game/dice_set"
require "greed_game/player"
#require "game"

module GreedGame

  def self.name
    "Greed Game"
  end
  
  def initialize(*names)
    raise "It should be 2 or more players in the game" if names.size < 2
    @dices = 5
    @players = Array.new
    names.each do |name|
      @players << Player.new(name)
    end
  end
  
  def in_progress
    max_score = 0
    last_round = false
    while  max_score < 3000 or not last_round
      @players.each do |player|
        player.roll(@dices)
      end
      player_whith_max_score = @players.max_by {|players| players.score_total }
      last_round = true if max_score >= 3000
      max_score = player_whith_max_score.score_total
    end
    @winner = Array.new
    @players.each do |player|
      @winner << player if player.score_total == max_score
    end
    @winner
  end
  
  def finished
    if @winner.count == 1
      text = "#{@winner[0].name} is winner"
    else
      text = "Winner is absent"
    end
    text
  end

end
