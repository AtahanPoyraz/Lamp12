# **LAMP Stack Installation Script**

**This script automates the installation and configuration of a LAMP (Linux, Apache, MariaDB, PHP) stack on a Debian 12 system.**


**Features**

- Updates system packages
- Configures hostname and time zone
- Modifies sources.list for package management

**Installs and configures**
- Apache2 web server
- MariaDB database server
- PHP and necessary modules
- Memcached for caching
- Secures MariaDB installation
- Configures PHP settings for optimal performance
- Enables necessary Apache modules
- Restarts Apache to apply changes

**Prerequisites**

- A fresh Debian 12 installation
- Root or sudo privileges

### Installation Steps
- Clone or download the script.
- Open the script and modify the parameters section according to your requirements.
- Run the script with the following command:
    ```bash
    chmod +x ./script/install_lamp.sh
    ```
    ```bash
    ./script/install_lamp.sh
    ```

- Reboot the system after installation:
    ```bash
    sudo reboot
    ```

### Default Configuration

* `Hostname: fdwh01`

* `FQDN: fdwh01.formdata.com.tr`

* `MariaDB Admin User: dbadmin`

* `MariaDB Password: Predefined in the script (change before running)`

* `Databases Created: EspoCRMDB, NextDB`

### Apache Configuration

* Enables important modules: `rewrite`, `headers`, `env`, `dir`, `mime`, etc.

* Reverse proxy modules are available but commented out (uncomment if needed).

### PHP Configuration

* Installed version: `PHP 8.2`

* Adjusted settings:

    * `max_execution_time = 360`

    * `memory_limit = 1024M`

    * `post_max_size = 512M`

    * `upload_max_filesize = 512M`

__Notes:__
Ensure you edit the script to update credentials and settings before running.
Backup important files before executing modifications. MariaDB security settings remove unnecessary users and set a root password.

### Troubleshooting

* If Apache or MariaDB does not start, check logs:
    ```bash
    systemctl status apache2
    systemctl status mariadb
    ```

* Ensure you have proper network connectivity for package installations.

## Authors

- [@AtahanPoyraz](https://www.github.com/AtahanPoyraz)


## License

[MIT](https://choosealicense.com/licenses/mit/)
