a = []

first = 0 
second = 1
a << first << second
elem = first + second

while elem < 100 do
  a << elem 
  first = second
  second = elem
  elem = first + second
end