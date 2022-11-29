puts "Enter a b c : "
a = gets.chomp.to_i
b = gets.chomp.to_i
c = gets.chomp.to_i

d = (b * b) - (4 * a * c) 

if d < 0
  puts "D = #{d}"
  puts "Korney netu"
elsif d == 0
  puts "D = #{d}"
  puts "koren : 1"
else
  x1 = (-b + Math.sqrt(d)) / 2 * a
  x2 = (-b - Math.sqrt(d)) / 2 * a
  puts "D = #{d}"
  puts "x1 = #{x1}"
  puts "x2 = #{x2}"
end