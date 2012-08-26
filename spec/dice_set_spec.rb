require 'spec_helper'

describe DiceSet do
  before(:each) {@dice = DiceSet.new; @dice.roll(5)}
  
  
  it "should create a dice set" do
    @dice.should_not be_nil
  end
  
  it "should be an array" do
    @dice.values.should be_is_a(Array)
  end
  
  it "should have valid array size" do
    @dice.values.size.should == 5
  end

  it "should return a set of integers between 1 and 6" do
    @dice.values.each do |value|
      value.should >= 1 && value.should <= 6
    end
  end
  
  it "values should not change unless dice explicitly rolled" do
    first_time = @dice.values
    second_time = @dice.values
    second_time.should == first_time
  end
  
  it "rolls should change dice values" do
    first_time = @dice.values
    @dice.roll(5)
    second_time = @dice.values
    second_time.should_not == first_time
  end
  
  it "should can roll different numbers of dice" do
    @dice.values.size.should == 5
    @dice.roll(3)
    @dice.values.size.should == 3
    @dice.roll(1)
    @dice.values.size.should == 1
  end
end