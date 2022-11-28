puts "Enter your name : "
name = gets.chomp

puts "Enter your height : "
height = gets.chomp.to_i

ideal_weight = ((height - 100) * 1.15).to_i

if ideal_weight >= 0
    puts "#{name}, your ideal weight is #{ideal_weight}"
else
    puts "Your weight is already optimal"
end