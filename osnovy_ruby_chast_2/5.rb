puts "Enter a day : "
day = gets.chomp.to_i
puts "Enter a month : "
month = gets.chomp.to_i
puts "Enter a year : "
year = gets.chomp.to_i

days = %w(31 28 31 30 31 30 31 31 30 31 30 31).map { | i | i.to_i}
vis = false

if year % 4 == 0 
  if year % 100 == 0
    if year % 400 == 0
      vis = true
    else
      vis = false
    end
  else
    vis = true
  end
else
  vis = false 
end

s = 0
days.each_with_index do | x, index |
  if index == month - 1
    break 
  else
    s += x
  end
end
s += day

if (vis == true && month > 2)
  s += 1
end

puts s 
puts vis