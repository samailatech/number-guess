#!/bin/bash

secret_number=$(( RANDOM % 1000 + 1 ))

read -p "Enter your username: " username

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Check if user exists
user_info=$($PSQL "SELECT * FROM users WHERE username = '$username'")

if [[ -z $user_info ]]; then
    echo "Welcome, $username! It looks like this is your first time here."
    # Add new user to database
    $PSQL "INSERT INTO users (username) VALUES ('$username')"
else
    # Extract games played and best game from database
    games_played=$(echo $user_info | cut -d '|' -f 2)
    best_game=$(echo $user_info | cut -d '|' -f 3)
    echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
fi

guesses=0
while true; do
    read -p "Guess the secret number between 1 and 1000: " guess
    
    # Validate if the guess is an integer
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

if [[ $best_game -eq 0 || $guesses -lt $best_game ]]; then
    $PSQL "UPDATE users SET games_played = games_played + 1, best_game = $guesses WHERE username = '$username'"
else
    $PSQL "UPDATE users SET games_played = games_played + 1 WHERE username = '$username'"
fi
#djcsdjd
#hidjada
#hhhgg
#qqqqq