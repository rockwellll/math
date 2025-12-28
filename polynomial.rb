class Polynomial
  def initialize(*coefficients)
    @coefficients = coefficients
  end

  def eval(x:)
    @coefficients
      .map
      .with_index { |coefficient, index| coefficient * (x.pow(index)) }
      .reduce(:+)
  end
end


polynomial = Polynomial.new(109, 5, 2)

puts polynomial.eval(x: 0) # 109
puts polynomial.eval(x: 1) # 116

# The Dealer is responsible for the "Sharing" phase of Shamir's Secret Sharing.
# It transforms a string into a mathematical curve and distributes coordinates (shares).
class Dealer
  # @param string [String] The secret message to be hidden.
  # @param k [Integer] The threshold: the minimum number of shares needed to unlock the secret.
  def initialize(string:, k:)
    @original = string
    @k = k
    @packed = calculate_packed_string
  end

  # Generates a set of unique coordinate points (shares) for participants.
  # @param n [Integer] The total number of people to receive a share.
  # @return [Array<Array<Integer>>] An array of points in the format [[x1, y1], [x2, y2]...].
  def create_shares(n:)
    n.times.map.with_index(1) do |_, index|
      [index, polynomial.eval(x: index)]
    end
  end

  private
    def polynomial
      @polynomial ||= Polynomial.new(*([@packed] + limit.times.map { rand(1000) }))
    end

    # We use 256 because each character (byte) has 256 possible values (0-255).
    # This treats the string as a giant "Base-256" number, where each character
    # is a digit. Multiplying by 256 "shifts" the previous characters to the
    # left to make room for the new one, ensuring that the order of characters
    # (e.g., "ba" vs "ab") results in a unique, distinct integer.
    def calculate_packed_string
      total = 0

      @original.chars.map(&:ord).each do |code_point|
        total = (total * 256) + code_point
      end

      total
    end

    # The number of random coefficients needed to ensure only 'k' shares can solve the puzzle.
    def limit
      @k - 1
    end
end
