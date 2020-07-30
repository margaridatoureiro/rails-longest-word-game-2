# frozen_string_literal: true

require 'set'
require 'json'
require 'open-uri'
# top-level
class GamesController < ApplicationController
  def new
    length = rand(1..20)
    @letters = ('A'..'Z').to_a.sample(length)
    # if you want a fixed length, just replace it by a number (e.g: 20)
    # another way: (0..20).map { ('a'..'z').to_a[rand(0..26)] }
  end

  def score
    word = params[:word]
    results = fetch_results(word)
    answer = word.upcase.chars.to_set
    letters = params[:letters].chars.to_set
    if answer.subset?(letters) == true
      results['found'] ? compute_score(letters, word)
      : @score = "Sorry, but #{word.capitalize} isn't a valid English word..."
    else
      @score = "Sorry, but #{word.capitalize} can't be built out of the original grid..."
    end
  end

  def fetch_results(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    JSON.parse(response)
  end

  def compute_score(letters, word)
    points = letters.length * 5
    @score = "Congratulations! #{word.capitalize} is a valid English word! Total points in this play: #{points}"
  end
end
