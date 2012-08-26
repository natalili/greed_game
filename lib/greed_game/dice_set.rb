 class DiceSet
   def roll(argument)
     @values = Array.new(argument){ rand(6)+1 } 
   end
    def values
      @values
    end
 end
