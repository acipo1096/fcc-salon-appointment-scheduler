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
    3) HAIR_CONDITIONING_TREATMENT ;;
    *) MAIN_MENU "Sorry, we don't offer that service. Please pick a different service." ;;
  esac
}

WOMENS_HAIRCUT() {
  echo -e "\nYou have selected the WOMEN'S HAIRCUT."
  BOOK_APPOINTMENT
}

MENS_HAIRCUT() {
   echo -e "\nYou have selected the MEN'S HAIRCUT."
   BOOK_APPOINTMENT
}

HAIR_CONDITIONING_TREATMENT () {
  echo -e "\nYou have selected the HAIR CONDITIONING TREATMENT."
  BOOK_APPOINTMENT
}

BOOK_APPOINTMENT() {
  # enter phone number
  echo "Please enter your phone number"
  read CUSTOMER_PHONE

  # check if phone number exists
  PHONE_NUMBER=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if phone number doesn't exist
  if [[ -z $PHONE_NUMBER ]]
  then
    echo $PHONE_NUMBER
    # ask for name
    echo -e "\nWhat is your name?"
    read CUSTOMER_NAME

    # Put data into services
   NAME=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
   CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/^ $|//')

  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_NAME_FORMATTED=$(echo $CUSTOMER_NAME | sed 's/^ $|//')
    echo -e "\nWelcome back, $CUSTOMER_NAME_FORMATTED!"
  fi


  # ask time
  echo -e "\nWhat time do you want to come in?"
  read SERVICE_TIME

  # get customer id
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  # get service name
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  SERVICE_NAME_FORMATTED=$(echo $SERVICE_NAME | sed 's/^ $|//')

  # create appointment
  NEW_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  
  echo -e "\nI have put you down for a $SERVICE_NAME_FORMATTED at $SERVICE_TIME, $CUSTOMER_NAME_FORMATTED."
}

MAIN_MENU