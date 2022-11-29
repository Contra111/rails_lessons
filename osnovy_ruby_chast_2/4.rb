a = %w[a e i o u y]
d = {}

a.each do | x | 
  d[x] = x.ord - 96 
end

puts d