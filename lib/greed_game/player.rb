class Player
  
  attr_reader :score_roll, :score_total
  attr_accessor :name
  
  def initialize(name)
    @name = name
    @score_roll = 0
    @score_total = 0
  end
  
  def calculate_non_scoring_dice(dice)
    @count = dice.count
    dice.uniq.each do |n|
      if n == 1
        @count = @count - dice.count(1)
      elsif n == 5
        @count = @count - dice.count(5)
      else
        @count = @count - 3 if dice.count(n) >= 3
      end
    end
    @count
  end
  
  def calculate_dice_for_next_roll(dice)
    calculate_non_scoring_dice(dice)
    if @count == 0 and dice.count > 0
      @count = 5
    elsif @count == dice.count
      @count = 0
    end
    @count = 0 unless next_roll?
    @count
  end
  
  def next_roll?
    if @count > 0
      puts "Player #{name}, You have #{@score} score and You can use #{@count} dice. \n" +
	   "If You want do roll, enter 'y'"
      answer = STDIN.gets.chop!
      answer == "y"
    else
      false
    end
  end
  
  def score(dice)
    @score = 0
    dice.uniq.each do |n|
      if n == 1
        c = dice.count(1)
        @score += 100 * dice.count(1) if c < 3
        @score += 1000 + 100 * (c - 3) if  c >= 3
      elsif n == 5
        c = dice.count(5)
        @score += 50 * c if c < 3
        @score += 5  * 100 + 50 * (c - 3) if c >= 3
      else
        c = dice.count(n)
        @score += n * 100 if c >= 3
      end
    end
    @score
  end
  
  def calculate_score_roll(score)
    score == 0 ? @score_roll = 0 : @score_roll += score
    @score = 0
    @score_roll
  end
  
  def calculate_score_total(score_roll)
    if @score_total == 0
      @score_total += score_roll if score_roll >= 300
    else
      @score_total += score_roll      
    end
    @score_roll = 0
    @score_total
  end
  
  def roll(dices)
    while dices > 0 
      dice_set = DiceSet.new
      dice_roll = dice_set.roll(dices)
      score = score(dice_roll)
      dices = calculate_dice_for_next_roll(dice_roll)
      score_roll = calculate_score_roll(score)
      calculate_score_total(score_roll) if dices == 0
    end
  end

end