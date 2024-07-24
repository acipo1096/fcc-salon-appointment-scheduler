#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~~ Alex's Salon ~~~"
echo -e "\nWelcome to Alex's Salon!"

MAIN_MENU () {

  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi

  echo -e "\nHow can we help you today? Please select a service:"
  SERVICES=$($PSQL "SELECT * FROM services")

  # Need to put quotation marks around echo variable, otherwise formatting won't work
  echo "$SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    $SERVICE_ID) BOOK_APPOINTMENT ;;
    *) MAIN_MENU "Sorry, we don't offer that service. Please pick a different service." ;;
  esac
}

WOMENS_HAIRCUT() {
  echo -e "\nYou have selected your service to be a WOMEN'S HAIRCUT."
  BOOK_APPOINTMENT
}

MENS_HAIRCUT() {
   echo -e "\nYou have selected your service to be a MEN'S HAIRCUT."
   BOOK_APPOINTMENT
}

HAIR_CONDITIONING_TREATMENT () {
  echo -e "\nYou have selected your service to be a HAIR CONDITIONING TREATMENT."
  BOOK_APPOINTMENT
}

BOOK_APPOINTMENT() {
  # enter phone number
  echo -e "\nPlease enter your phone number"
  read PHONE_NUMBER

  # check if phone number exists
  CUSTOMER_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$PHONE_NUMBER'")

  # if phone number doesn't exist
  if [[ -z $CUSTOMER_PHONE ]]
  then
    echo $CUSTOMER_PHONE
    # ask for name
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME

    # Put data into services
   CUSTOMER_NAME=$($PSQL "INSERT INTO customers(phone,name) VALUES('$PHONE_NUMBER','$CUSTOMER_NAME')")

    # confirm entry
    if [[ $CUSTOMER_NAME == 'INSERT 0 1' ]]
    then
      echo $CUSTOMER_NAME
    fi
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$PHONE_NUMBER'")
    echo -e "\nWelcome back, $CUSTOMER_NAME!"
  fi


  # ask time
  echo -e "\nWhat time do you want to come in?"
  read SERVICE_TIME

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$PHONE_NUMBER'")
  
  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  # create appointment
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  
  # Use a regex to get rid of space
  echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU