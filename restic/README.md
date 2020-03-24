# Restic automatic backup

## Quick start

### Creating a configuration file

Create a configuration file which includes all the restic environment variables needed for your backup. Put the file under `/etc/restic`. (e.g: `/etc/restic/local.conf`)

Here is an example (you can find the file here: [`local.conf`](./local.conf)):

    # restic environment variables have to be declared in here

    # restic remote repository
    #
    # check restic documentation for 
    # additional env vars to
    # support AWS/Backblaze backends. e.g:
    # B2_ACCOUNT_ID=xxx
    # B2_ACCOUNT_KEY=xxx
    RESTIC_REPOSITORY=/backup/restic
    # repository's password
    RESTIC_PASSWORD=Something

    # local path to backup
    PATH_TO_BACKUP=/

    # retention rules
    RETENTION_DAYS=45
    RETENTION_WEEKS=12
    RETENTION_MONTHS=9
    RETENTION_YEARS=2

    # files exclusion list
    EXCLUDE_LIST="--exclude /somewhere"
    
    # list of args to pass to restic
    RESTIC_BACKUP_ARGS="$EXCLUDE_LIST"

### Systemd units installation

Install this repo's systemd units found in `systemd/` to `/etc/systemd/user/`.

From inside the `systemd/` directory, run:

    # cd into systemd/ first
    for x in *; do cp $x /etc/systemd/user; done
    
### Starting the services

I have wrote a main backup unit, [`run-backup`](./systemd/run-backup@.service), and several timers / helpers to handle the automatic backups.

If you want to run a **one-shot backup**, run:

    # this assumes that you created /etc/restic/local.conf
    systemctl start run-backup@local.service

If you want to run **monthly backups**, you have to start the [`monthly-backup`](./systemd/monthly-backup@.timer) timer.

    # this assumes that you created /etc/restic/local.conf
    systemctl start monthly-backup@local.timer

You can find the other timers in `systemd/`.

## Configuration file structure

The configuration file is sourced before calling restic therefore you may use restic's environment variables as needed. If you use **AWS**, **BackBlaze**, etc, you might need to export some specific repository's variable.

You can find the documentation here: [restic environment variables.](https://restic.readthedocs.io/en/latest/040_backup.html#environment-variables).

| Name                | Description                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `PATH_TO_BACKUP`    | Your **local** path to backup. **(required)**                                                                                                                                                                                                                                                                                                                                               |
| `RESTIC_BACKUP_ARGS`   | A space separated list of extra arguments to be passed to restic.                                                                                                                                                                                                                                                                                                                                                |
| `RETENTION_DAYS`     | Keep the last **x** daily snapshots. **(required)**                                                                                                                                                                                                                                                                                                                             |
| `RETENTION_WEEKS`     | Keep the last **x** weekly snapshots. **(required)**                                                                                                                                                                                                                                                                                                                                           |
| `RETENTION_MONTHS`     | Keep the last **x** monthly snapshots. **(required)**                                                                                                                                                                                                                                                                                                                                               |
| `RETENTION_YEARS`     | Keep the last **x** yearly snapshots. **(required)**                                                                                                                                                                                                                                                                                                                                              |

## Using the configuration file without systemd

You can also source the environment variables in the configuration file to invoke restic without the systemd service. This might be useful to restore a backup or debug restic.

You can put this simple bash function into your `.bashrc` for the sake of comfort:

    source_restic () {
      RESTIC_CONF=/etc/restic/$1.conf

      if [ ! -f "$RESTIC_CONF" ]; then
        echo "$RESTIC_CONF does not exist"
        return
      fi

      echo "Sourcing $RESTIC_CONF"

      source $RESTIC_CONF
      for x in `cut -d "=" -f1 $RESTIC_CONF`; do
        export $x
      done
    }

In this way it's just a matter of:

    $ source_restic local
    # $ restic <whatever>
