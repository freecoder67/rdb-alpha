#!/bin/bash

DB="number_guess.db"

# Create database and tables if they don't exist
sqlite3 $DB <<EOF
CREATE TABLE IF NOT EXISTS users (
  user_id INTEGER PRIMARY KEY AUTOINCREMENT,
  username VARCHAR(22) UNIQUE NOT NULL
);

CREATE TABLE IF NOT EXISTS games (
  game_id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  guesses INTEGER NOT NULL,
  FOREIGN KEY(user_id) REFERENCES users(user_id)
);
EOF

# Prompt for username
echo "Enter your username:"
read USERNAME

# Get user info
USER_ID=$(sqlite3 $DB "SELECT user_id FROM users WHERE username='$USERNAME';")

if [[ -z $USER_ID ]]
then
  sqlite3 $DB "INSERT INTO users(username) VALUES('$USERNAME');"
  USER_ID=$(sqlite3 $DB "SELECT user_id FROM users WHERE username='$USERNAME';")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
else
  GAMES_PLAYED=$(sqlite3 $DB "SELECT COUNT(*) FROM games WHERE user_id=$USER_ID;")
  BEST_GAME=$(sqlite3 $DB "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID;")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESSES=0

echo "Guess the secret number between 1 and 1000:"

while true
do
  read GUESS

  if ! [[ $GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
    continue
  fi

  ((GUESSES++))

  if [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  elif [[ $GUESS -lt $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  else
    break
  fi
done

# Save game result
sqlite3 $DB "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $GUESSES);"

echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"