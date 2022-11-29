puts "Enter a b c "
a = gets.chomp.to_i
gip = a
b = gets.chomp.to_i
if b > a
  gip = b
  katet1 = a
else
  katet1 = b
end
c = gets.chomp.to_i
if c > gip
  katet2 = gip
  gip = c
else
  katet2 = c
end

puts katet1, katet2, gip 

if katet1 ^ 2 + katet2 ^ 2 == gip ^ 2
  puts "Pryamougolny"
elsif katet1 == katet2 && katet2 == gip
  puts "Ravnostoronniy"
end
if katet1 == katet2 || katet2 == gip || gip == katet1
  puts "Ravnobedrenniy"
end