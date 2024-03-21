#!/bin/bash

# Parameters for connecting to the librenms database
LIBRENMS_DB_HOST='localhost'
LIBRENMS_DB_NAME='your_librenms_db'
LIBRENMS_DB_USER='your_librenms_user'
LIBRENMS_DB_PASSWORD='your_librenms_password'

# Parameters for connecting to the guacamole database
GUACAMOLE_DB_HOST='localhost'
GUACAMOLE_DB_NAME='your_guacamole_db'
GUACAMOLE_DB_USER='your_guacamole_user'
GUACAMOLE_DB_PASSWORD='your_guacamole_password'

# Connection to the librenms database
mysql_librenms="mysql -h $LIBRENMS_DB_HOST -u $LIBRENMS_DB_USER -p$LIBRENMS_DB_PASSWORD $LIBRENMS_DB_NAME"

# Connection to the guacamole database
mysql_guacamole="mysql -h $GUACAMOLE_DB_HOST -u $GUACAMOLE_DB_USER -p$GUACAMOLE_DB_PASSWORD $GUACAMOLE_DB_NAME"

# Retrieving data from the devices table in the librenms database
devices=$($mysql_librenms -N -e "SELECT hostname, sysName FROM devices;")

# Checking for the existence of the guacamole_connection table in the guacamole database
if ! $($mysql_guacamole -e "DESCRIBE guacamole_connection" >/dev/null 2>&1); then
  echo "Error: guacamole_connection table does not exist in the guacamole database."
  exit 1
fi

# Checking for the existence of the guacamole_connection_parameter table in the guacamole database
if ! $($mysql_guacamole -e "DESCRIBE guacamole_connection_parameter" >/dev/null 2>&1); then
  echo "Error: guacamole_connection_parameter table does not exist in the guacamole database."
  exit 1
fi

# Iterating through the rows of the devices table
while read -r hostname sysName; do

  # Checking for the existence of already created connection_id in guacamole_connection
  if [ $($mysql_guacamole -N -e "SELECT COUNT(*) FROM guacamole_connection WHERE connection_name = '$sysName'") -gt 0 ]; then
    echo "Connection with the name $sysName already exists in the guacamole_connection table."
    continue
  fi

  max_conn_id=$($mysql_guacamole -N -e "SELECT MAX(connection_id) FROM guacamole_connection;")
  if [ -z "$max_conn_id" ]; then
    conn_id=1
  else
    conn_id=$((max_conn_id+1))
  fi

  $mysql_guacamole -e "INSERT INTO guacamole_connection (connection_id, connection_name, protocol) VALUES ($conn_id, '$sysName', 'ssh');"
  $mysql_guacamole -e "INSERT INTO guacamole_connection_parameter (connection_id, parameter_name, parameter_value) VALUES ($conn_id, 'hostname', '$hostname');"
  $mysql_guacamole -e "INSERT INTO guacamole_connection_parameter (connection_id, parameter_name, parameter_value) VALUES ($conn_id, 'username', '\${GUAC_USERNAME}');"
  $mysql_guacamole -e "INSERT INTO guacamole_connection_parameter (connection_id, parameter_name, parameter_value) VALUES ($conn_id, 'color-scheme', 'green-black');"

done <<< "$devices"