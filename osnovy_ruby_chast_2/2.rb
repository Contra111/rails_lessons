a =[]

(10..100).each do | x |
  if x % 5 == 0 
    a << x
  end
end

puts a