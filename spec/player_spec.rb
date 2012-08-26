require 'spec_helper'

describe Player do
  before(:each) {@player = Player.new("player1")}
  
  context "New" do
    
    it "should have a name" do
      @player.instance_variables.include?(:@name).should == true
    end
  
    it "should return a name" do
      @player.name.should == "player1"
    end
  
    it "should set name" do
      @player.name = "Player 1"
      @player.name.should == "Player 1"
    end
  
    it "should have a current roll's score" do
      @player.instance_variables.include?(:@score_roll).should == true
    end
  
    it "should have zero roll's score" do
      @player.score_roll.should == 0
    end

    it "should rise exception if roll's score is set" do
      expect { @player.score_roll = 300 }.to raise_error(NoMethodError)    
    end
  
    it "should have total score" do
      @player.instance_variables.include?(:@score_total).should == true
    end
  
    it "should have zero total score" do
      @player.score_total.should == 0
    end
  
    it "should rise exception if total score is set" do
      expect { @player.score_total = 3000 }.to raise_error(NoMethodError)    
    end
  end
  
  context "Calculate non-scoring dices" do
    
      it "should be zero if dices are absent" do
	@player.calculate_non_scoring_dice([]).should == 0
      end
      
      it "should be zero if all of the thrown dices are scoring" do
	@player.calculate_non_scoring_dice([5]).should == 0
	@player.calculate_non_scoring_dice([1]).should == 0
	@player.calculate_non_scoring_dice([2,2,2]).should == 0
	@player.calculate_non_scoring_dice([3,3,3]).should == 0
	@player.calculate_non_scoring_dice([4,4,4]).should == 0
	@player.calculate_non_scoring_dice([6,6,6]).should == 0
	@player.calculate_non_scoring_dice([1,5,3,3,3]).should == 0
      end
      
      it "should return the count of 2s, 3s, 4s, and 6s" do
	@player.calculate_non_scoring_dice([2,3,4,6]).should == 4
      end
      
      it "should return the count of non-scoring dices for mixed dice sets" do
	@player.calculate_non_scoring_dice([2,2,2,3,4]).should == 2
	@player.calculate_non_scoring_dice([1,5,6,4,2]).should == 3
      end
  
  end
  
  context "Calculate count of dices for next roll" do
  before(:each) {@player.stub!(:next_roll?).and_return(true)}
    
      it "should be zero if dices are absent" do
	@player.calculate_dice_for_next_roll([]).should == 0
      end
      
      it "should be 5 if all of the thrown dices are scoring" do
	@player.calculate_dice_for_next_roll([1]).should == 5
	@player.calculate_dice_for_next_roll([3,3,3]).should == 5
	@player.calculate_dice_for_next_roll([5,5,4,4,4]).should == 5
      end
      
      it "should be zero for 2s, 3s, 4s, and 6s" do
	@player.calculate_dice_for_next_roll([2,3,4,6,4]).should == 0
      end
      
      it "should return the count of dices for mixed dice sets" do
	@player.calculate_dice_for_next_roll([3,2,2,2]).should == 1
	@player.calculate_dice_for_next_roll([4,2,5,1,1]).should == 2
      end
      
  end
  
  context "Next roll?" do

    it "should return false if player not have dices for next roll" do 
      @player.instance_variable_set("@count", 0)
      @player.should_not be_next_roll
    end
    
    it "should return true if player enter 'y'" do 
      @player.instance_variable_set("@count", 1)
      STDIN.stub!(:gets).and_return("y\n")
      @player.should be_next_roll
    end
    
    it "should return false if player enter not 'y'" do 
      @player.instance_variable_set("@count", 1)
      STDIN.stub!(:gets).and_return("")
      @player.should_not be_next_roll
    end
    
  end
  
  describe "Score" do
    context "For dice" do
      
      it "should be zero if dices are absent" do
	@player.score([]).should == 0
      end
      
      it "should be 50 for single roll of 5" do
	@player.score([5]).should == 50
      end
      
      it "should be 100 for single roll of 1" do
	@player.score([1]).should == 100
      end
      
      it "should return the sum of individual scores for multiple 1s and 5s" do
	@player.score([1,5,5,1]).should == 300
      end
      
      it "should be zero for single 2s, 3s, 4s, and 6s" do
	@player.score([2,3,4,6]).should == 0
      end
      
      it "should be 1000 for a triple 1" do
	@player.score([1,1,1]).should == 1000
      end
      
      it "should return 100x for other triples" do
	@player.score([2,2,2]).should == 200
	@player.score([3,3,3]).should == 300
	@player.score([4,4,4]).should == 400
	@player.score([5,5,5]).should == 500
	@player.score([6,6,6]).should == 600
      end
      
      it "should return sum for mixed dice sets" do
	@player.score([2,5,2,2,3]).should == 250
	@player.score([5,5,5,5]).should == 550
      end
      
    end
    
    context "Roll's" do
      
      it "should be zero for new player" do
	@player.score_roll.should == 0
      end
      
      it "should be zero if score is zero" do
	@player.calculate_score_roll(0).should == 0
	@player.score_roll.should == 0
      end
    
      it "should increase by score for dice" do
	score = @player.score([1])
	expect { @player.calculate_score_roll(score) }.to change{ @player.score_roll }.by(score)
      end
      
      it "should set zero for score" do
	@player.calculate_score_roll(0)
	@player.instance_variable_get("@score").should == 0
	@player.calculate_score_roll(100)
	@player.instance_variable_get("@score").should == 0
      end
      
    end
    
    context "Total" do
      
      it "should be zero for new player" do
	@player.score_total.should == 0
      end

      it "should not increase if total score is zero and roll's score less than 300" do
	expect { @player.calculate_score_total(250) }.to_not change{ @player.score_total }
      end

      it "should increase if total score is zero and roll's score equal 300" do
	expect { @player.calculate_score_total(300) }.to change{ @player.score_total }.by(300)
      end

      it "should increase if total score is zero and roll's score more than 300" do
	expect { @player.calculate_score_total(400) }.to change{ @player.score_total }.by(400)
      end
      
      it "should increase if total score more than zero and roll's score more than zero" do
        @player.instance_variable_set(:@score_total, 500)
        expect{ @player.calculate_score_total(200) }.to change{ @player.score_total }.from(500).to(700)
      end

      it "should set zero for roll's score" do
	@player.calculate_score_total(0)
	@player.instance_variable_get("@score_roll").should == 0
	@player.calculate_score_total(300)
	@player.instance_variable_get("@score_roll").should == 0
      end

    end
  end
    
  context "Roll" do
      
    it "should not increase score total if dices are absent" do
      dices = 0
      expect { @player.roll(dices) }.to_not change{ @player.score_total }
    end
      
    it "should increase score total if amount dices more than zero" do
      dices = 5
      @player.instance_variable_set(:@score_total, 500)
      @player.stub!(:calculate_dice_for_next_roll).and_return(0)
      @player.stub!(:calculate_score_roll).and_return(200)
      expect{ @player.roll(dices) }.to change{ @player.score_total }.from(500).to(700)
    end
      
  end
end