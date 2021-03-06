class Game < ApplicationRecord
    has_many :user_games
    has_many :users, through: :user_games
    has_many :game_questions
    has_many :questions, through: :game_questions

end
