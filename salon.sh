#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

#Main menu
echo -e "\n~~~ Salon ~~~"

MAIN_MENU(){
 if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
echo -e "\nHow can we help you today?"
AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services;")
echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
#GET USER MENU SELECTION
read SERVICE_ID_SELECTED

 case $SERVICE_ID_SELECTED in
    1) SCHEDULE_APPOINTMENT ;;
    2) SCHEDULE_APPOINTMENT ;;
    3) SCHEDULE_APPOINTMENT ;;
    4) EXIT ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac
}
#schedule appointment
SCHEDULE_APPOINTMENT(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  #get customer id
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
  #if not found
  if [[ -z $GET_CUSTOMER_ID ]]
  then
  #create new customer
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
  fi
  #set appointment time
  #update CUSTOMER_ID
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE';")
  echo -e "\nWhen would you like to schedule your appointment for?"
  read SERVICE_TIME
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME');")
  GET_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $GET_CUSTOMER_ID;")
  GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED';")
  CUSTOMER_FORMATTED=$(echo $GET_CUSTOMER_NAME | sed 's/ |/"/')
  SERVICE_FORMATTED=$(echo $GET_SERVICE_NAME | sed 's/ |/"/')
  TIME_FORMATTED=$(echo $SERVICE_TIME | sed 's/ |/"/')
  echo -e "I have put you down for a $SERVICE_FORMATTED at $TIME_FORMATTED, $CUSTOMER_FORMATTED."
}
EXIT(){
  echo -e "\nThanks for stopping in!"
}
#get customer phone number
#if not found
#create new customer
MAIN_MENU