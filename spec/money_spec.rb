require File.dirname(__FILE__) + '/spec_helper'

describe Money do
  
  before(:each) do
    @money = Money.new
  end
  
  it "should be contructable with empty class method" do
    Money.empty.should == @money
  end
  
  it "should return itself with to_money" do
    @money.to_money.should equal(@money)
  end
  
  it "should default to 0 when constructed with no arguments" do
    @money.should == Money.new(0.00)
  end
  
  it "should to_s as a float with 2 decimal places" do
    @money.to_s.should == "0.00"
  end
  
  it "should be constructable with a BigDecimal" do
    Money.new(BigDecimal.new("1.23")).should == Money.new(1.23)
  end
  
  it "should be constructable with a Fixnum" do
    Money.new(3).should == Money.new(3.00)
  end
  
  it "should be construcatable with a Float" do
    Money.new(3.00).should == Money.new(3.00)
  end
  
  it "should be addable" do
    (Money.new(1.51) + Money.new(3.49)).should == Money.new(5.00)
  end
  
  it "should be able to add $0 + $0" do
    (Money.new + Money.new).should == Money.new
  end
  
  it "should be subtractable" do
    (Money.new(5.00) - Money.new(3.49)).should == Money.new(1.51)
  end
  
  it "should be subtractable to $0" do
    (Money.new(5.00) - Money.new(5.00)).should == Money.new
  end
  
  it "should be substractable to a negative amount" do
    (Money.new(0.00) - Money.new(1.00)).should == Money.new("-1.00")
  end
  
  it "should inspect to a presentable string" do
    @money.inspect.should == "#<Money value:0.00>"
  end
  
  it "should be inspectable within an array" do
    [@money].inspect.should == "[#<Money value:0.00>]"
  end
  
  it "should correctly support eql? as a value object" do
    @money.should eql(Money.new)
  end
  
  it "should be addable with integer" do
    (Money.new(1.33) + 1).should == Money.new(2.33)
  end
  
  it "should be addable with float" do
    (Money.new(1.33) + 1.50).should == Money.new(2.83)
  end
  
  it "should be multipliable with an integer" do
    (Money.new(1.00) * 55).should == Money.new(55.00)
  end
  
  it "should be multiplable with a float" do
    (Money.new(1.00) * 1.50).should == Money.new(1.50)
  end
  
  it "should be multipliable by a cents amount" do
    (Money.new(1.00) * 0.50).should == Money.new(0.50)
  end
  
  it "should be multipliable by a repeatable floating point number" do
    (Money.new(24.00) * (1 / 30.0)).should == Money.new(0.80)
  end
  
  it "should round multiplication result with fractional penny of 5 or higher up" do
    (Money.new(0.03) * 0.5).should == Money.new(0.02)
  end
  
  it "should round multiplication result with fractional penny of 4 or lower down" do
    (Money.new(0.10) * 0.33).should == Money.new(0.03)
  end
  
  it "should be divisible by a fixnum" do
    (Money.new(55.00) / 55).should == Money.new(1.00)
  end

  it "should be divisible by an integer" do
    (Money.new(2.00) / 2).should == Money.new(1.00)
  end
  
  it "should round to the lowest cent value during division" do
    (Money.new(2.00) / 3).should == Money.new(0.67)
  end
  
  it "should return cents in to_liquid" do
    Money.new(1.00).to_liquid.should == 100
  end
  
  it "should return cents in to_json" do
    Money.new(1.00).to_liquid.should == 100
  end
  
  it "should support absolute value" do
    Money.new(-1.00).abs.should == Money.new(1.00)
  end
  
  it "should support to_i" do
    Money.new(1.50).to_i.should == 1
  end
  
  it "should support to_f" do
    Money.new(1.50).to_f.to_s.should == "1.5"
  end
  
  it "should be creatable from an integer value in cents" do
    Money.from_cents(1950).should == Money.new(19.50)
  end
  
  it "should be creatable from an integer value of 0 in cents" do
    Money.from_cents(0).should == Money.new
  end
  
  it "should be creatable from a float cents amount" do
    Money.from_cents(1950.5).should == Money.new(19.51)
  end
  
  it "should raise when constructed with a NaN value" do
    lambda{ Money.new( 0.0 / 0) }.should raise_error
  end
  
  it "should be comparable with non-money objects" do
    @money.should_not == nil
  end
  
  describe "frozen with amount of $1" do
    before(:each) do
      @money = Money.new(1.00).freeze
    end

    it "should == $1" do
      @money.should == Money.new(1.00)
    end
    
    it "should not == $2" do
      @money.should_not == Money.new(2.00)
    end
    
    it "<=> $1 should be 0" do
      (@money <=> Money.new(1.00)).should == 0
    end
    
    it "<=> $2 should be -1" do
      (@money <=> Money.new(2.00)).should == -1
    end
    
    it "<=> $0.50 should equal 1" do
      (@money <=> Money.new(0.50)).should == 1
    end
    
    it "should have the same hash value as $1" do
      @money.hash.should == Money.new(1.00).hash
    end
    
    it "should not have the same hash value as $2" do
      @money.hash.should == Money.new(1.00).hash
    end

  end
  
  describe "with amount of $0" do
    before(:each) do
      @money = Money.new
    end
    
    it "should be zero" do
      @money.should be_zero
    end
    
    it "should be greater than -$1" do
      @money.should be > Money.new("-1.00")
    end
    
    it "should be greater than or equal to $0" do
      @money.should be >= Money.new
    end
    
    it "should be less than or equal to $0" do
      @money.should be <= Money.new
    end
    
    it "should be less than $1" do
      @money.should be < Money.new(1.00)
    end
  end

  describe "with amount of $1" do
    before(:each) do
      @money = Money.new(1.00)
    end
    
    it "should not be zero" do
      @money.should_not be_zero
    end
    
    it "should have a decimal value = 1.00" do
      @money.value.should == BigDecimal.new("1.00")
    end
    
    it "should have 100 cents" do
      @money.cents.should == 100
    end
    
    it "should return cents as a Fixnum" do
      @money.cents.should be_an_instance_of(Fixnum)
    end
    
    it "should be greater than $0" do
      @money.should be > Money.new(0.00)
    end
    
    it "should be less than $2" do
      @money.should be < Money.new(2.00)
    end
    
    it "should be equal to $1" do
      @money.should == Money.new(1.00)
    end
  end
  
  describe "with amount of $1 with created with 3 decimal places" do
    before(:each) do
      @money = Money.new(1.125)
    end
    
    it "should round 3rd decimal place" do
      @money.value.should == BigDecimal.new("1.13")
    end
  end
end