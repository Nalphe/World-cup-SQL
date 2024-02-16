#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE teams, games")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
 do
  # ENTER TEAMS
   if [[ $WINNER != "winner" || $OPPONENT != "opponent"  ]]
    then
     TEAM_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER' AND name='$OPPONENT'")
   
     if [[ -z $TEAM_NAME  ]]
      then
        WINNER_NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
        OPPONENT_NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
         if [[ -z $WINNER_NAME ]] 
          then
            INSERT_WINNER_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
            if [[ $INSERT_WINNER_NAME == "INSERT 0 1" ]]
              then
                echo "$WINNER has been inserted into teams"
            fi
         fi
         if [[ -z $OPPONENT_NAME ]]
          then
            INSERT_OPPONENT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
             if [[ $INSERT_OPPONENT_NAME == "INSERT 0 1" ]]
               then
                 echo "$OPPONENT has been inserted into teams"
             fi
         fi
      fi
      #Enter game details (not unique)
      GET_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      GET_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

      INSERT_GAME=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$GET_WINNER_ID,$GET_OPPONENT_ID,$W_GOALS,$O_GOALS)");
      
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
        then
          echo "$WINNER v $OPPONENT in $YEAR: game inserted"
      fi
   fi
 done
