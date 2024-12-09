#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

secret_number=$(( RANDOM % 1000 + 1 ))

echo "Enter your username:"
read username

# Retrieve existing user data
user_info=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username = '$username'")

if [[ -z $user_info ]]; then
    # New user
    echo "Welcome, $username! It looks like this is your first time here."
    $PSQL "INSERT INTO users (username, games_played, best_game) VALUES ('$username', 0, 0)"
    games_played=0
    best_game=0
else
    # Existing user
    IFS='|' read db_username games_played best_game <<< "$user_info"
    echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

# Start the game
guesses=0
while true; do
    echo "Guess the secret number between 1 and 1000:"
    read guess

    if ! [[ "$guess" =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
    elif (( guess < secret_number )); then
        echo "It's higher than that, guess again:"
    elif (( guess > secret_number )); then
        echo "It's lower than that, guess again:"
    else
        guesses=$((guesses + 1))
        echo "You guessed it in $guesses tries. The secret number was $secret_number. Nice job!"
        break
    fi

    guesses=$((guesses + 1))
done

# Update games_played and best_game
if [[ -z $best_game || $best_game -eq 0 || $guesses -lt $best_game ]]; then
    $PSQL "UPDATE users SET games_played = games_played + 1, best_game = $guesses WHERE username = '$username'"
else
    $PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$username'"
fi

#djcsdjd
#hidjada
#hhhgg
#qqqqq