pg_dump -U freecodecamp -d number_guess -f number_guess_dump.sql
camper: /project$ psql --username=freecodecamp --dbname=postgres
psql (12.22 (Ubuntu 12.22-0ubuntu0.20.04.4))
Type "help" for help.

postgres=> CREATE DATABASE number_guess;
CREATE DATABASE
postgres=> 
postgres=> \c number_guess
You are now connected to database "number_guess" as user "freecodecamp".
number_guess=> 
number_guess=> CREATE TABLE users(
number_guess(>   user_id SERIAL PRIMARY KEY,
number_guess(>   username VARCHAR(22) UNIQUE NOT NULL,
number_guess(>   games_played INT DEFAULT 0,
number_guess(>   best_game INT
number_guess(> );
CREATE TABLE
number_guess=> pg_dump -U freecodecamp -d number_guess -f number_guess.sql
number_guess-> pg_dump
number_guess-> CREATE TABLE users(
  user_id SERIAL PRIMARY KEY,
  username VARCHAR(22) UNIQUE NOT NULL,
  games_played INT DEFAULT 0,
  best_game INT
);
ERROR:  syntax error at or near "pg_dump"
LINE 1: pg_dump -U freecodecamp -d number_guess -f number_guess.sql
        ^
number_guess=> pg_dump -U freecodecamp -d number_guessing_game -f numb
er_guess.sql
number_guess-> pg_dump -U freecodecamp -d number_guess -a -f number_guess_data.sql
number_guess-> pg_dump -U freecodecamp -d number_guess -f number_guess_dump.sql
