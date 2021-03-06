# frozen_string_literal: true

require 'pry'
class Cli
  attr_accessor :drink, :ingredient, :additional_ingredient

  @@cash = []
  def start
    puts 'Bartender: Welcome, please have a seat'
    puts ''
    puts ''
    sleep(1)
    options
  end

  def options
    puts '1. Order a drink. 2. Ask for a dealers choice. 3. See your bill. 4. Settle up and leave.'
    puts ''
    puts ''
    user_input = gets.chomp
    case user_input.to_i
    when 1
      sleep(1)
      got_one_in_mind?
    when 2
      sleep(1)
      rando
    when 3
      sleep(1)
      bill
    when 4
      sleep(1)
      exit
    else
      puts 'Please try again'
      puts ''
      options
    end
  end

  def got_one_in_mind?
    puts 'Bartender: Got one in mind?'
    user_input = gets.strip
    api = Api.new(user_input)

    details = api.fetch_drink
    if details

      puts "Bartender: Here is your #{details.drink}. it has #{details.ingredient} and a little #{details.additional_ingredient}."
      puts ''
    else
      sorry
    end
    sleep(1)
    puts 'Bartender: Wanna know how I made it?'
    nu_input = gets.strip
    if nu_input == 'yes'
      puts "Bartender: #{details.instructions}"
      puts ''
      puts ''
      tip
      options
    elsif tip
      options
    end
  end

  def tip
    puts 'How much would you like to tip?'
    puts '$1  $2  $3'
    user_input = gets.strip
    @@cash << user_input.to_i
  end

  def self.cash
    @@cash
  end

  def sorry
    puts "Bartender: Ain't got that for ya"
    got_one_in_mind?
  end

  def exit
    puts 'Bartender: Here is your bill, goodnight.'

    if Operator.all.empty?

    else
      Operator.all.each do |drink_in|
        sleep(1)
        puts drink_in.drink
      end
      Kernel.exit
    end
  end

  def bill
    if Operator.all.empty?
      puts "You haven't ordered anything. Are you drunk?"
      sleep(2)
      options

    else
      Operator.all.each do |drink_in|
        sleep(1)
        puts drink_in.drink
      end
      options
    end
  end

  def rando
    api = Api.new

    details = api.dealers_choice
    puts "Bartender: Here is your #{details.drink}. it has #{details.ingredient} and a little #{details.additional_ingredient}."

    puts 'Bartender: Wanna know how I made it?'
    nu_input = gets.strip
    if nu_input == 'yes'
      puts "Bartender: #{details.instructions}"
      tip
      options
    elsif tip
      options
    end
  end
end
