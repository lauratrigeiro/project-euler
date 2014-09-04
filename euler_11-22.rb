# Solutions for Project Euler.net using Ruby - Problems 11-12, 16-17, 19, 22

require 'prime'

# Problem 11: Largest product in a grid
# What is the greatest product of four adjacent numbers in the 
# same direction (up, down, left, right, or diagonally) in the 20×20 grid?
=end
my_filename = "C:\\Users\\Owner\\Documents\\2014\\p011_grid.txt"
grid = File.readlines(my_filename)
grid.each_index do |r| 
	grid[r] = grid[r].split(" ")
	grid[r].each_index { |c| grid[r][c] = grid[r][c].to_i}
end

largest = 0         	# Assume grid is not all 0s
prod_length = 4
nrow = grid.length
ncol = grid[0].length   # Assume all rows are the same length
(0...nrow).each do |r|
	(0...ncol).each do |c|
		curr_prod = -1
		next if grid[r][c] == 0

		# Check across
		if c + prod_length - 1 < ncol
			curr_prod = grid[r][c]
			(1...prod_length).each { |i| curr_prod *= grid[r][c + i] }
		end
		largest = [largest, curr_prod].max

		# Check down
		if r + prod_length - 1 < nrow
			curr_prod = grid[r][c]
			(1...prod_length).each { |i| curr_prod *= grid[r + i][c] }
		end
		largest = [largest, curr_prod].max

		# Check down-right diagonal
		if r + prod_length - 1 < nrow && c + prod_length - 1 < ncol
			curr_prod = grid[r][c]
			(1...prod_length).each { |i| curr_prod *= grid[r + i][c + i] }
		end
		largest = [largest, curr_prod].max
		
		# Check down-left diagonal
		if r + prod_length - 1 < nrow && c - prod_length + 1 >= 0
			curr_prod = grid[r][c]
			(1...prod_length).each { |i| curr_prod *= grid[r + i][c - i] }
		end
		largest = [largest, curr_prod].max
	end
end

puts "Problem 11: #{largest}"

# Problem 12: Highly divisible triangular number
# What is the value of the first triangle number to have over five hundred divisors?

def factors_of(n)
	factors = []
	sqrt = (Math.sqrt(n)).floor
	(1..sqrt).each do |f|
		if n % f == 0
			factors << f
			factors << n / f if (n / f) != f
		end
	end
	factors.sort
end
n = 1
while true do
	tri = n * (n + 1) / 2
	tri_factors = factors_of(tri)
	n += 1
	break if tri_factors.length > 500
end

puts "Problem 12: #{tri}"  	# Solution: 76_576_500

# faster
# If N = p1^a1 * p2^a2 * p3^a3 * ... then 
# Divisors(N) = (a1 + 1) * (a2 + 1) * (a3 + 1) * ...

n = 1
while true do
	divisors = 1
	tri = n * (n + 1) / 2
	tri_prime_fact = Prime.prime_division(tri)
	tri_prime_fact.each  do |a|
		divisors *= a[1] + 1
	end
	n += 1
	break if divisors > 500
end

puts "Problem 12 (fast): #{tri}"  	# Solution: 76_576_500

# Problem 16: Power digit sum
# 2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.
# What is the sum of the digits of the number 2^1000?

big_num_sum = 0
big_num = 2 ** 1000
big_num_digits = (big_num.to_s).split(//)
big_num_digits.each { |d| big_num_sum += d.to_i}

puts "Problem 16: #{big_num_sum}"		# Solution: 1366

# Problem 17: Number letter counts
# If the numbers 1 to 5 are written out in words: one, two, three,
# four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
# If all the numbers from 1 to 1000 (one thousand) inclusive were written 
# out in words, how many letters would be used? 
# Do NOT count spaces, hypens. DO use 'and'

# Hard way
def hundreds_english(n)
	# 0 < n < 1000
	return "invalid" if n < 1 || n > 999
	n_english = ""
	digit_words = ["zero", "one", "two", "three", "four", "five", "six", "seven",
					"eight", "nine"]
	tens_words = [nil, nil, "twenty", "thirty", "forty", "fifty", "sixty",
					"seventy", "eighty", "ninety"]
	teens_words = ["ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen",
					"sixteen", "seventeen", "eighteen", "nineteen"]
	hundreds_place = n / 100
	tens_place = (n % 100) / 10
	ones_place = n % 10
	if hundreds_place > 0
		n_english << "#{digit_words[hundreds_place]} hundred" 
		n_english << " and " if n % 100 > 0
	end
	if tens_place == 1
		n_english << "#{teens_words[ones_place]}" 
	else
		if tens_place > 1
			n_english << "#{tens_words[tens_place]}"
			n_english << "-" if ones_place > 0
		end
		n_english << "#{digit_words[ones_place]}" if ones_place > 0
	end
	n_english
end

def number_to_english(n)
	return "zero" if n == 0
	return "invalid" if n > 999_999
	n_english = ""
	thousands = n / 1000
	hundreds = n % 1000
	if thousands > 0
		n_english << hundreds_english(thousands) + " thousand"
		return n_english if hundreds == 0
		n_english << " " 
	end
	n_english << hundreds_english(hundreds)
	n_english
end

total_letters = 0
(1..1000).each do |n|
	n_english = number_to_english(n)
	n_english.delete! " -"
	total_letters += n_english.length
end

puts "Problem 17: #{total_letters}"  # Solution: 21_124

# Problem 19: Counting Sundays
# How many Sundays fell on the first of the month during the 
# twentieth century (1 Jan 1901 to 31 Dec 2000)?
# A leap year occurs on any year evenly divisible by 4, 
# but not on a century unless it is divisible by 400.

def leap_year (year)
	if year % 4 != 0 || (year % 100 == 0 && year % 400 != 0)
		return false
	end
	true
end

day_of_week = 0 # Sunday
month_days = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
(1..12).each { |i| month_days[i] = month_days[i] % 7} 
sundays = 0
year = 1901
m_index = 1
while (year < 2001) do
	sundays += 1 if day_of_week == 0
	day_of_week += month_days[m_index]
	day_of_week += 1 if m_index == 2 && leap_year(year)  # Is if Feb of a leap year?
	day_of_week = day_of_week % 7
	m_index += 1
	if m_index > 12 		# Happy New Year!
		year += 1
		m_index = 1
	end
end

puts "Problem 19: #{sundays}"	# Solution: 171

# Problem 22: Name scores
# Using names.txt, a 46K text file containing over five-thousand first names, 
# begin by sorting it into alphabetical order. Then working out the 
# alphabetical value for each name, multiply this value by its alphabetical 
# position in the list to obtain a name score.
# For example, when the list is sorted into alphabetical order, COLIN, 
# which is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938th name in the list. 
# So, COLIN would obtain a score of 938 × 53 = 49714.
# What is the total of all the name scores in the file?

def name_score (name)
	name.downcase!
	score = 0
	name.each_char { |c| score += c.ord - 96}
	score
end

filename = "C:\\Users\\Owner\\Documents\\2014\\p022_names.txt"
# file = File.open(filename)
 name_string =  File.read(filename)
name_string.delete! '"'
names = name_string.split(',')
names.sort!
total_score = 0
names.each_with_index do |x, i|
	score = name_score(x)
	total_score += score * (i + 1)
end

puts "Problem 22: #{total_score}" # Solution: 871_198_282
