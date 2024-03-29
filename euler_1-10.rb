# Solutions for Project Euler.net Problems 1-10 using Ruby
# by Laura Trigeiro

require 'prime'

# Problem 1: Multiples of 3 and 5
# If we list all the natural numbers below 10 that are multiples of 3 or 5, 
# we get 3, 5, 6 and 9. The sum of these multiples is 23.
# Find the sum of all the multiples of 3 or 5 below 1000.

sum = 0
for num in 1...1000 do 
	sum += num if num % 3 == 0 || num % 5 == 0		
end
puts "Problem 1: #{sum}" # Solution: 233,168

# Problem 2: Even Fibonacci numbers
# Each new term in the Fibonacci sequence is generated by adding the previous two terms. 
# By starting with 1 and 2, the first 10 terms will be:
# 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...
# By considering the terms in the Fibonacci sequence whose values do not exceed 
# four million, find the sum of the even-valued terms.
sum = 0
fib1 = 1; fib2 = 2
while (fib2 < 4_000_000) do
	sum += fib2 if fib2 % 2 == 0
	temp = fib1 + fib2
	fib1 = fib2
	fib2 = temp
end
puts "Problem 2: #{sum}"  # Solution: 4,613,732

# Problem 3: Largest prime factor
# The prime factors of 13195 are 5, 7, 13 and 29.
# What is the largest prime factor of the number 600851475143 ?

# The hard way (not usually built in Ruby classes)
def isPrime?(n)
	for f in 2..n/2 do
		if n % f == 0
			return false
		end
	end
	return true
end

$primes = []
def primeFactors(n)
	if isPrime?(n)
		$primes << n
		return $primes
	end
	(3..n/2).step(2) do |f|
		if n % f == 0 && isPrime?(f)
			$primes << f
			return primeFactors(n/f)
		end
	end
	return $primes
end
puts "Problem 3 (hard way): #{primeFactors(600_851_475_143)[$primes.length-1]}"

# The easy way
result = Prime.prime_division(600_851_475_143)
puts "Problem 3 (easy way): #{result[result.length-1][0]}" # Solution: 6857

# Problem 4: Largest palindrome product
# A palindromic number reads the same both ways. The largest palindrome made
# from the product of two 2-digit numbers is 9009 = 91 × 99.
# Find the largest palindrome made from the product of two 3-digit numbers.

def isPalindrome?(n)
	nstring = n.to_s
	if nstring == nstring.reverse
		true
	else
		false
	end
end

largest = 0

999.downto(101) do |a|
	a.downto(101) do |b|
		if a*b <= largest
			break
		end
		if isPalindrome?(a*b) 
			largest = a*b
		end
	end
end
puts "Problem 4: #{largest}" # Solution: 906_609

# Problem 5: Smallest multiple
# 2520 is the smallest number that can be divided by each of the numbers from
# 1 to 10 without any remainder.
# What is the smallest positive number that is evenly divisible by all of the
# numbers from 1 to 20?

# Easy way
# 2*3*(2)*5*_*7*(2)*(3)*_*11*_*13*_*_*(2)*17*19*_
#      4    6    8   9  10   12  14 15 16       20
# Only multiply by new factors
prob5 = 2*3*2*5*7*2*3*11*13*2*17*19
puts "Problem 5: #{prob5}" # Solution: 232_792_560

# Computer way
product = 1
for n in 2..20 do
	if isPrime?(n)
		product *= n
	else
		product *= (n / n.gcd(product))
	end
end
puts "Problem 5 (computer way): #{product}"

# Problem 6: Sum square difference
# The sum of the squares of the first ten natural numbers is,
# 1^2 + 2^2 + ... + 10^2 = 385
# The square of the sum of the first ten natural numbers is,
# (1 + 2 + ... + 10)2 = 552 = 3025
# Hence the difference between the sum of the squares of the 
# first ten natural numbers and the square of the sum is 3025 − 385 = 2640.
# Find the difference between the sum of the squares of the 
# first one hundred natural numbers and the square of the sum.

sum_squares = 0
square_sum = 0

(1..100).each do |n|
	sum_squares += n*n
	square_sum += n
end
square_sum *= square_sum 
# Alternatively, for square_sum use the formula n(n+1)/2
puts "Problem 6: #{square_sum-sum_squares}" # Solution: 25_164_150

# Problem 7: 10001st prime
# By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, 
# we can see that the 6th prime is 13.  What is the 10 001st prime number?

# Ruby's Prime checking method works much faster than mine because isPrime? 
# doesn't use any special properties of primes.
num_primes = 1
n = 3
while num_primes <= 10_001
#	if isPrime?(n)
	if Prime.prime?(n)
		num_primes += 1
		if num_primes == 10_001
			my_prime = n
		end
	end
	n +=2
end
puts "Problem 7: #{my_prime}" # Solution: 104_743

# Problem 8: 

def arrayProduct(a)
	product = 1
	(0..a.length-1).each do |i|
		product *= a[i]
	end
	product
end

num_digits = 13
digits = []
greatest_product = 0
 large_num = 7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450

while large_num > 0
	d = large_num % 10
	large_num /= 10
	if d == 0
		digits = []
	elsif digits.length < num_digits-1
		digits << d
	else
		if digits.length >= num_digits
			last_product /= digits[0]
			digits.shift(1)		
		end
		digits << d
		last_product = arrayProduct(digits)
		if last_product > greatest_product
			greatest_product = last_product
		end
	end
end

puts "Problem 8: #{greatest_product}" # Solution: 23_514_624_000

# Problem 9: Special Pythagorean Triple
# A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
# a^2 + b^2 = c^2      For example, 32 + 42 = 9 + 16 = 25 = 52.
# There exists exactly one Pythagorean triplet for which a + b + c = 1000.
# Find the product abc.
pythag_product = 0
(1..333).each do |a|
	(a+1..666).each do |b|
		c = Math.sqrt(a*a + b*b) 
		if c == c.floor && a + b + c == 1000
			pythag_product = a * b * c
			# Pythagorean Triple: puts "#{a}, #{b}, #{c.floor}"
			break;
		end
	end
end

puts "Problem 9: #{pythag_product.floor}" # Solution: 31_875_000

# Problem 10: Summation of primes
# The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.
# Find the sum of all the primes below two million.

# Easy way: this definitely takes awhile
prime_sum = 0
Prime.each(2_000_000) do |prime|
	prime_sum += prime
end

puts "Problem 10: #{prime_sum}"

# Hard way?
