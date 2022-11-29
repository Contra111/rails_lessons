h = {}

loop do
  a = {}
  puts "Vvedite nazvanie tovara ili stop : "
  tovar = gets.chomp
  break if tovar == "stop"
  puts "cena : "
  cena = gets.chomp.to_i
  puts "kolvo : "
  kolvo = gets.chomp.to_f
  a[cena] = kolvo
  h[tovar] = a 
end

puts h
result = 0
h.each do |key, value|
  summa = value.keys[0].to_f * value[value.keys[0]].to_f
  puts "Itogovaya summa za #{key} : #{ summa }"
  result += summa
end

puts result