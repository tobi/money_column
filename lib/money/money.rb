require 'bigdecimal'
require 'bigdecimal/util'

class Money
  include Comparable
  
  attr_reader :value, :cents

  def initialize(value = 0)
    raise ArgumentError if value.respond_to?(:nan?) && value.nan?
    
    @value = value_to_decimal(value).round(2)
    @cents = (@value * 100).to_i
  end
  
  def <=>(other)
    cents <=> other.cents
  end
  
  def +(other)
    Money.new(value + other.to_money.value)
  end

  def -(other)
    Money.new(value - other.to_money.value)
  end
  
  def *(numeric)
    Money.new(value * numeric)
  end
  
  def /(numeric)
    Money.new(value / numeric)
  end
    
  def inspect
    "#<#{self.class} value:#{self.to_s}>"
  end
  
  def ==(other)
    eql?(other)
  end
  
  def eql?(other)
    self.class == other.class && value == other.value
  end
  
  def hash
    value.hash
  end
  
  def self.parse(input)
    MoneyParser.parse(input)
  end
  
  def self.empty
    Money.new
  end
  
  def self.from_cents(cents)
    Money.new(cents.round.to_f / 100)
  end
  
  def to_money
    self
  end
  
  def zero?
    value.zero?
  end
  
  # dangerous, this *will* shave off all your cents
  def to_i
    value.to_i
  end
  
  def to_f
    value.to_f
  end
  
  def to_s
    sprintf("%.2f", value.to_f)
  end
  
  def to_liquid
    cents
  end

  def to_json(options = {})
    cents
  end
  
  def abs
    Money.new(value.abs)
  end
  
  private
  # poached from Rails
  def value_to_decimal(value)
    # Using .class is faster than .is_a? and
    # subclasses of BigDecimal will be handled
    # in the else clause
    if value.class == BigDecimal
      value
    elsif value.respond_to?(:to_d)
      value.to_d
    else
      value.to_s.to_d
    end
  end
end

