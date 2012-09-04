require "greed_game/version"
require "greed_game/dice_set"
require "greed_game/player"

module GreedGame

  def self.name
    "Greed Game"
  end
  
  def initialize(*names)
    raise "It should be 2 or more players in the game" if names.size < 2
    @dices = 5
    @max_score = 0
    @players = Array.new
    names.each do |name|
      @players << Player.new(name)
    end
  end
  
  def in_progress
    while  next_round?
      calculate_max_score
      @players.each do |player|
        player.roll(@dices)
      end
    end
    winner
  end
  
  def finished
    return "#{@winner[0].name} is winner" if @winner.count == 1
    "Winner is absent"
  end
  
  private
  
  def next_round?
    @max_score < 3000 ? true : false
  end
  
  def calculate_max_score
    player_whith_max_score = @players.max_by {|players| players.score_total }
    @max_score = player_whith_max_score.score_total
  end
  
  def winner
    calculate_max_score
    @winner = Array.new
    @players.each do |player|
      @winner << player if player.score_total == @max_score
    end
    @winner
  end
  
end
