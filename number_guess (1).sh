#!/bin/bash

# Number Guessing Game Script
# This script generates a random number between 1 and 1000 and lets the user guess it.
# It tracks user statistics in a PostgreSQL database.

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Ensure the users table exists
$PSQL "CREATE TABLE IF NOT EXISTS users (username VARCHAR(22) PRIMARY KEY, games_played INT DEFAULT 0, best_game INT);"

# Generate a random secret number
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
NUMBER_OF_GUESSES=0

# Prompt for username
echo "Enter your username:"
read USERNAME

# Validate username length
if [[ ${#USERNAME} -gt 22 ]]
then
  echo "Username must be 22 characters or less."
  exit 1
fi

# Check if user exists in database
USER_INFO=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")

if [[ -z $USER_INFO ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 0, NULL)")
  GAMES_PLAYED=0
  BEST_GAME=0
else
  IFS="|" read GAMES_PLAYED BEST_GAME <<< $USER_INFO
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Function to handle the guessing game
GUESSING_GAME() {
  echo "Guess the secret number between 1 and 1000:"
  read GUESS

  while [[ $GUESS != $SECRET_NUMBER ]]
  do
    if ! [[ $GUESS =~ ^[0-9]+$ ]]
    then
      echo "That is not an integer, guess again:"
    else
      if (( GUESS > SECRET_NUMBER ))
      then
        echo "It's lower than that, guess again:"
      else
        echo "It's higher than that, guess again:"
      fi
    fi

    ((NUMBER_OF_GUESSES++))
    read GUESS
  done

  ((NUMBER_OF_GUESSES++))
}

GUESSING_GAME

echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

# Update user statistics
NEW_GAMES=$((GAMES_PLAYED + 1))

if [[ -z $BEST_GAME || $BEST_GAME -eq 0 || $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
then
  UPDATE_USER=$($PSQL "UPDATE users SET games_played=$NEW_GAMES, best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'")
else
  UPDATE_USER=$($PSQL "UPDATE users SET games_played=$NEW_GAMES WHERE username='$USERNAME'")
fi
