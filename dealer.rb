require './playable'

class Dealer
  include Playable

  attr_reader :cards

  def initialize(first_card, secound_card)
    @cards = [first_card, secound_card]
  end

  def finished?
    total >= 17
  end

end