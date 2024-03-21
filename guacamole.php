<?php

// Database connection parameters
$GUACAMOLE_DB_HOST = 'localhost';
$GUACAMOLE_DB_USER = 'guacamole-user';
$GUACAMOLE_DB_PASSWORD = 'password';
$GUACAMOLE_DB_NAME = 'guacamole';

// URL base
$GUACAMOLE_URL = 'guacamole_url';

// Checking if the ssh parameter is passed in the URL
if (!isset($_GET['ssh'])) {
    die('The ssh parameter was not passed in the URL');
}

// Extracting the value of the ssh parameter from the URL
$sshParam = $_GET['ssh'];

// Parsing the URL to get the IP address value
$urlParts = parse_url($sshParam);
if (!isset($urlParts['host'])) {
    die('IP address not found in the ssh parameter');
}
$ip = $urlParts['host'];

// Connecting to the database
$mysqli = new mysqli($GUACAMOLE_DB_HOST, $GUACAMOLE_DB_USER, $GUACAMOLE_DB_PASSWORD, $GUACAMOLE_DB_NAME);

// Checking database connection
if ($mysqli->connect_error) {
    die('Database connection error: ' . $mysqli->connect_error);
}

// Getting the connection id from the database
$sql = "SELECT connection_id FROM guacamole_connection_parameter WHERE parameter_value = '$ip';";
$result = $mysqli->query($sql);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $id = $row['connection_id'];

    // Forming the required URL using base64
    $nullByte = chr(0);
    $base64 = base64_encode($id . $nullByte . 'c' . $nullByte . 'mysql');
    $url = $GUACAMOLE_URL . $base64;

    // Redirecting to the new URL
    header('Location: ' . $url);
    exit();
} else {
    die('Connection not found');
}

?>