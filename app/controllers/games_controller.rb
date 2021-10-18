require 'open-uri'

class GamesController < ApplicationController
  def new
    all_letters = %w[A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]
    @letters = []
    grid = []
    10.times { @letters << all_letters[rand(25)] }
  end

  def score
    @word = params[:word]
    @raw_letters = params[:letters]
    @letters = params[:letters].gsub(' ', '').split(//)
    @result = ''
    if attempt_inside_grid?(@word, @letters)
      if english_word?(@word)
        @result = 'win'
      else
        @result = 'noword'
      end
    else
      @result = 'nogrid'
    end
  end

  def attempt_inside_grid?(attempt, grid)
    att_arr = attempt.upcase.chars
    (att_arr - grid).empty? && too_many_chars?(att_arr, grid)
  end

  def too_many_chars?(attempt, grid)
    sub_array = grid.select { |value| attempt.include?(value) }
    sub_array.size >= attempt.size
  end

  def english_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    api_answer_serialized = URI.open(url).read
    api_answer = JSON.parse(api_answer_serialized)
    api_answer['found']
  end
end
