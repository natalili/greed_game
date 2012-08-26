require 'spec_helper'

describe GreedGame do
  before(:each) do
    class Game
      include GreedGame
    end
    @game = Game.new("player1", "player2")
  end
    
  context "#name" do
    it "shuld return gem name" do
      GreedGame.name.should == "Greed Game"
    end
  end
  
  context "New" do
    it "should create game with 2 or more players" do
      @game.instance_variable_get(:@players).size.should == 2
      @game = Game.new("player1", "player2", "player3")
      @game.instance_variable_get(:@players).size.should == 3
    end
    
    it "should rise exception with 1 player" do
      expect { Game.new("player1") }.to raise_error('It should be 2 or more players in the game')
    end

    it "should use 5 dices" do
      @game.instance_variable_get(:@dices).should == 5
    end
    
    it "should have score total is zero" do
      @game.instance_variable_get(:@players).max_by {|players| players.score_total }.score_total. should == 0
    end
  end
    
  context "In progress" do
  before(:each) {@game.instance_variable_get(:@players)[0].stub!(:next_roll?).and_return(false)
                 @game.instance_variable_get(:@players)[1].stub!(:next_roll?).and_return(false)}
    
    it "should have a player with score total is more 3000" do
      @game.in_progress
      @game.instance_variable_get(:@players).max_by {|players| players.score_total }.score_total. should >= 3000
    end
    
    it "should return array with winners" do
      @game.in_progress.should_not == []
      @game.instance_variable_get(:@winner).count.should > 0
    end

    it "should return player with maximal score total" do
      @game.instance_variable_get(:@players)[0].stub!(:score_total).and_return(30000)
      @game.in_progress[0].name.should == "player1"
      @game.instance_variable_get(:@winner)[0].name.should == "player1"
      @game.instance_variable_get(:@winner).count.should == 1
    end
  end
  
  context "Finished" do
    
    it "should return who is winner if one player have maximal score total" do
      @game.instance_variable_set(:@winner , Array.new << Player.new("player1"))
      @game.finished.should == "player1 is winner"
    end
    
    it "should return 'Winner is absent' if array with winners is empty" do
      @game.instance_variable_set(:@winner, Array.new)
      @game.finished.should == "Winner is absent"
    end

    it "should return 'Winner is absent' if more than one player have maximal score total" do
      @game.instance_variable_set(:@winner, @game.instance_variable_get(:@players))
      @game.finished.should == "Winner is absent"
    end

  end
end