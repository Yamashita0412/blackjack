# require './lib/playable'
require './playable'


class Player
  include Playable

  attr_reader :cards

  def initialize(first_card, secound_card)
    @cards = [first_card, secound_card]
    @stand = false
  end

  def finished?
    total >= 21 || stand?
  end

  def twenty_one?
    total == 21
  end

  def stand!
    @stand = true
  end

  def stand?
    @stand
  end

end