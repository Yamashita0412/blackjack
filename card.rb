class Card
  SUITS = %i(heart diamond club spade)
  NUMBERS = ['A', *'2'..'9', '10', 'J', 'Q', 'K']

  attr_reader :suit, :number

  def self.generate_cards
    SUITS.product(NUMBERS).map { |suit, n| self.new(suit, n)}
  end

  def initialize(suit, number)
    @suit = suit
    @number = number
  end

  def point
    case number
    when 'A'
      1
    when 'J', 'Q', 'K'
      10
    else
      number.to_i
    end
  end

  def to_s
    "#{suit_text}の#{number}"
  end

  def suit_text
    case suit
    when :heart
      'ハート'
    when :diamond
      'ダイヤ'
    when :club
      'クラブ'
    when :spade
      'スペード'
    else
      raise "Unknown suit: #{suit}"
    end
  end

end