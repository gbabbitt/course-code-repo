#!/usr/bin/env ruby

puts "What is your first name?"
name = gets.chomp
sleep(1)
puts "Interesting name."
sleep(1)
puts "Ok, #{name}. Ask me a yes or no question and I will predict your future!"
question = gets.chomp
sleep(1.5)
puts "Uhh...."
sleep(1)

x = rand(8)
# puts x

answer0 = "Hmm. Thats a tricky one. Im guessing... yes"
answer1 = "Certainly not"
answer2 = "Im not sure. Try again #{name}."
answer3 = "No way."
answer4 = "Why, yes."
answer5 = "I thought there was no such thing as a dumb question #{name}."
answer6 = "What kind of question is that?!?!"
answer7 = "Why are you asking me? It's not like I'm a magic 8 ball or something!"

if x == 0
    puts answer0
elsif x == 1
    puts answer1
elsif x == 2
    puts answer2
elsif x == 3
    puts answer3
elsif x == 4
    puts answer4
elsif x == 5
    puts answer5
elsif x == 6
    puts answer6
elsif x == 7 
    puts answer7
end












