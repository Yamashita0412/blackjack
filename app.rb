require './card'
require './dealer'
require './player'

class App

  def self.run
    self.new.run
  end

  def run
    @results = []

    puts "Welcome to BlackJack!"
    puts_blank_row

    begin
      init_app
      show_intro
      result = play_game
      @results << result
      show_result(result)
    end while try_again?

    puts "GoodBye!"
  end

  private

    def init_app
      @cards = generate_cards
      @player = Player.new(*@cards.shift(2))
      @dealer = Player.new(*@cards.shift(2))
    end

    def generate_cards
      Card.generate_cards.shuffle
    end

    def show_intro
      puts "[#{ordinal_count}回線]"
      puts "ゲーム開始"
      puts_blank_row

      @player.cards.each do |card|
        show_player_card(card)
      end

      puts_blank_row

      show_dealer_card(@dealer.cards[0])
      puts "ディーラーの２枚目のカードはわかりません"

      puts_blank_row
    end

    def play_game
      until @player.finished?
        player_hit_or_stand
      end

      if @player.bust?
        puts "#{@player.total}点でバスとしました"
        gets_return
        puts_blank_row
        return :lose
      end

      show_dealer_total
      gets_return
      puts_blank_row

      show_player_total
      show_dealer_total

      case @player.total <=> @dealer.total
      when 1
        :win
      when -1
        :lose
      else
        :draw
      end
    end

    def show_result(result)
      puts result_text(result)
      puts_blank_row

      win, lose, draw = result_counts
      puts "対戦成績: #{win}勝#{lose}負#{draw}分"

      count_all = win + lose
      percentage = count_all.zero? ? 0.0 : 100.0 * win / (win + lose)
      puts "勝率:#{percentage.floor(1)}%"
    end

    def try_again?
      puts_blank_row
      puts "終了！もう一戦しますか？"
      answer = gets_yes?
      puts_blank_row
      answer
    end

    def player_hit_or_stand
      puts "あなたの現在の得点は#{@player.total}です。"
      puts "カードを引きますか？"
      if gets_yes?
        puts_blank_row
        card = @cards.shift
        @player.hit(card)
        show_player_card(card)
      else
        @player.stand!
      end
    end

    def dealer_hit
      puts "ディーラーの現在の得点は#{@dealer.total}です。"
      gets_return
      puts_blank_row
      card = @cards.shift
      @dealer.hit(card)
      show_dealer_card(card)
    end

    def gets_yes?
      begin
        printf "y/n: "
        input = gets.chomp.downcase
      end until %w(y n).include?(input)
      input == 'y'
    end

    def gets_return
      print "press return: "
      gets
    end

    def show_player_card(card)
      puts "あなたが引いたカードは#{card}です。"
    end

    def show_dealer_card(card)
      puts "ディーラーが引いたカードは#{card}です。"
    end

    def show_player_total
      puts "あなたの得点は#{@player.total}です。"
    end

    def show_dealer_total
      puts "ディーラーの得点は#{@dealer.total}です。"
    end

    def result_text(result)
      case result
      when :win then "あなたの勝ちです！"
      when :lose then "あなたの負けです。"
      when :draw then "引き分けです。"
      else raise "Unknown result: #{result}"
      end
    end

    def ordinal_count
      @results.size + 1
    end

    def result_counts
      @results.each_with_object(Hash.new(0)) { |result, h| h[result] += 1}
      .values_at(:win, :lose, :draw)
    end

    def puts_blank_row
      puts
    end
end

if __FILE__ == $0
  App.run
end