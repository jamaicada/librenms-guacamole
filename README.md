# librenms-guacamole
Integration Apache Guacamole with LibreNMS.

1. Install Apache Guacamole (you'll find dozen of how-to's in google)
2. Put guacamole.php to librenms html directory
3. Put import.sh wherever you fill comfortable to run scripts in cron
4. Adjust guacamole.sh and import.sh according you database access credentials (all parameters are pretty self explanatory)
5. Adjust your LibreNMS config.php with
```php
$config['gateone']['server'] = 'http://localhost/guacamole.php';
```
where localhost is where your run your LibreNMS
6. Start guacamole.sh and optionally - you can run it in cron every N minutes.