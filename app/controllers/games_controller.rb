require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def in_grid(attempt, grid)
    letters = attempt.chars
    letters.each do |letter|
      if grid.include?(letter.upcase)
        grid.split.delete_at(grid.index(letter.upcase))
      else
        return false
      end
    end
    return true
  end

  def score
    if in_grid(params[:word], params[:letters])
      response = open("https://wagon-dictionary.herokuapp.com/#{params[:word]}")
      json = JSON.parse(response.read)
      if json['found']
        @score = params[:word].length ** 2
        return @answer = "Congratulations! #{params[:word]} is an English word."
      else
        @score = 0
        return @answer = "Sorry! #{params[:word]} is not an English word."
      end
    else
      @score = 0
      return @answer = "Sorry but #{params[:word]} can't be built out of
      these #{params[:letters]}"
    end
  end
end
