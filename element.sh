#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"
#PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

UNFOUND_MSG="I could not find that element in the database."

if [[ -z $1 ]]; then
  echo -e "Please provide an element as an argument."
else
  QUERY="SELECT atomic_number, symbol, type, atomic_mass, name, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id)"
  CONDITION=""

  if [[ $1 =~ ^[0-9]+$ ]]; then
    CONDITION="elements.atomic_number=$1"
  else
    CONDITION="elements.symbol='$1' OR elements.name='$1'"
  fi

  QUERY="$QUERY WHERE $CONDITION"
  INFO=$($PSQL "$QUERY")

  if [[ -z $INFO ]]; then
    echo "$UNFOUND_MSG"
  else
    echo "$INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR NAME BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS; do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi

