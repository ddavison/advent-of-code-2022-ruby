# frozen_string_literal: true

plays = []
endings = {
  X: :lose,
  Y: :draw,
  Z: :win
}

# ===== Part One Below =====
Moves = Struct.new(:opponent, :player).new({
  A: :rock,
  B: :paper,
  C: :scissors
}, {
  X: :rock,
  Y: :paper,
  Z: :scissors
})

class Play
  attr_accessor :player_move, :opponent_move, :ending

  def initialize(opponent_move, ending)
    @opponent_move = opponent_move
    @ending = ending

    public_send(ending)
  end

  def win
    case opponent_move
    when :rock; @player_move = :paper
    when :paper; @player_move = :scissors
    when :scissors; @player_move = :rock
    end
  end

  def lose
    case opponent_move
    when :rock; @player_move = :scissors
    when :paper; @player_move = :rock
    when :scissors; @player_move = :paper
    end
  end

  def draw
    @player_move = opponent_move
  end

  def score
    case ending
    when :win; scores[:win] + scores[player_move]
    when :draw; scores[:draw] + scores[player_move]
    when :lose; scores[:lose] + scores[player_move]
    end
  end

  def to_s
    "Opponent: #{opponent_move}; Ending: #{ending}, Player: #{player_move} (#{score})"
  end

  private

  def scores
    {
      win: 6,
      draw: 3,
      lose: 0,

      rock: 1,
      paper: 2,
      scissors: 3
    }
  end
end
# Play = Struct.new(:opponent_move, :ending, :player_move) do
#   def initialize
#     public_send(ending)
#   end
#
#   def scores
#     {
#       win: 6,
#       tie: 3,
#       loss: 0,
#
#       rock: 1,
#       paper: 2,
#       scissors: 3
#     }
#   end
#
#   # To win the game, play this move
#   def win
#
#   end
#
#   # To lose the game, play this move
#   def lose
#
#   end
#
#   # To draw the game, play this move
#   def draw
#     self.player_move = opponent_move
#   end
#
#   # X beats C
#   # Y beats A
#   # Z beats B
#   def won?
#     case player_move
#     when :X; opponent_move == :C
#     when :Y; opponent_move == :A
#     when :Z; opponent_move == :B
#     end
#   end
#
#   # A beats Z
#   # B beats X
#   # C beats Y
#   def lost?
#     case opponent_move
#     when :A; player_move == :Z
#     when :B; player_move == :X
#     when :C; player_move == :Y
#     end
#   end
#
#   def tied?
#     Moves.opponent[opponent_move] == Moves.player[player_move]
#   end
#
#   def score
#     return scores[:win] + scores[Moves.player[player_move]] if won?
#     return scores[:tie] + scores[Moves.player[player_move]] if tied?
#
#     scores[:loss] + scores[Moves.player[player_move]]
#   end
# end
# ===== Part One Above =====

File.readlines('lib/day_2/input.txt').each do |line|
  opp, ending = line.split
  plays << Play.new(Moves.opponent[opp.to_sym], endings[ending.to_sym])
end

# Part One
puts plays.map(&:score).reduce(&:+)
