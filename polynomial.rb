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
