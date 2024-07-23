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
  echo -e "\n1) Women's Haircut\n2) Men's Haircut\n3) Hair Conditioning Treatment"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) WOMENS_HAIRCUT ;;
    2) MENS_HAIRCUT ;;
    3) HAIR_CONDITIONING_TREATMENT;;
    *) MAIN_MENU "Sorry, we don't offer that service. Please pick a different service." ;;
  esac
}

WOMENS_HAIRCUT() {
  # enter phone number
  echo -e "\nPlease enter your phone number"
  read PHONE_NUMBER

  # check if phone number exists
  CUSTOMER_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone='$PHONE_NUMBER'")

  # if phone number doesn't exist
  if [[ -z $PHONE_EXISTS ]]
  then
    # ask for name
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME

    # Put data into services
    NEW_CUSTOMER=$($PSQL "INSERT INTO customers(phone,name) VALUES('$PHONE_NUMBER','$CUSTOMER_NAME')")

    # confirm entry
    if [[ $NEW_CUSTOMER == 'INSERT 0 1' ]]
    then
      echo $NEW_CUSTOMER
    fi
  else
    echo
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

MENS_HAIRCUT() {
  echo "You have selected Men's Haircut as your service."
}

HAIR_CONDITIONING_TREATMENT () {
  echo "You have selected a hair conditioning treatment as your service."
}

MAIN_MENU