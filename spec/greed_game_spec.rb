require 'spec_helper'

describe GreedGame do
  
  context "#name" do
    it "shuld return gem name" do
      GreedGame.name.should == "Greed Game"
    end
  end
  
end