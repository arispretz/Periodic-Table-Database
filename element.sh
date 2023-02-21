#!/bin/bash

# Program to print information of an element from periodic_table database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if argument is not found
if [[ -z $1 ]]
then
echo "Please provide an element as an argument."
exit
fi

# if argument is a number
if [[ $1 =~ ^[0-9]+$ ]]
then
ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, symbol, name, type, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE atomic_number=$1")
else
# if argument is a symbol or name
ELEMENT=$($PSQL "SELECT atomic_number, atomic_mass, symbol, name, type, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING (atomic_number) LEFT JOIN types USING (type_id) WHERE symbol = '$1' OR name = '$1'")
fi

# if element not found
if [[ -z $ELEMENT ]]
then
echo "I could not find that element in the database."
exit
fi

# give information
echo $ELEMENT | while IFS=" |" read ATOMIC_NUMBER ATOMIC_MASS SYMBOL NAME TYPE MELTING_POINT BOILING_POINT
do
echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
