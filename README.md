# librenms-guacamole
Integration Apache Guacamole with LibreNMS - you'll be able to SSH to your devices using SSH button just using your browser. But be carefull - with power comes great responsibility. 

1. Install Apache Guacamole (you'll find dozen of how-to's in google)
2. Put guacamole.php to librenms html directory
3. Put import.sh wherever you fill comfortable to run scripts in cron
4. Adjust guacamole.sh according you database access credentials (all parameters are pretty self explanatory) and
```php
$GUACAMOLE_URL = 'https://localhost/ssh/#/client/'
```
where https://localhost/ssh/ url where you had configured to run Apache Guacamole

5. Adjust import.sh according you database access credentials (all parameters are pretty self explanatory)
6. Adjust your LibreNMS config.php with
```php
$config['gateone']['server'] = 'http://localhost/guacamole.php';
```
where localhost is where your run your LibreNMS

7. Start guacamole.sh and optionally - you can run it in cron every N minutes.