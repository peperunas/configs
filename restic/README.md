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
    RESTIC_ARGS="$EXCLUDE_LIST"

### Systemd units installation

Install this repo's systemd units found in `systemd/` to `~/.config/systemd/user/`.

### Enable and/or starting the services

I have wrote a main backup unit, [`run-backup`](./systemd/run-backup@.service), and several timers / helpers to handle the automatic backups.

If you want to run a **one-shot backup**, run:

    # this assumes that you created /etc/restic/local.conf
    systemctl start run-backup@local.service

If you want to run **monthly backups**, you have to enable the [`monthly-backup`](./systemd/monthly-backup@.timer) timer.

    # this assumes that you created /etc/restic/local.conf
    systemctl enable monthly-backup@local.timer

You can find the other timers in `systemd/`.

## Configuration file structure

The configuration file is sourced before calling restic therefore you may use restic's environment variables as needed. If you use **AWS**, **BackBlaze**, etc, you might need to export some specific repository's variable.

You can find the documentation here: [restic environment variables.](https://restic.readthedocs.io/en/latest/040_backup.html#environment-variables).


| Name                | Description                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `PATH_TO_BACKUP`    | Your **local** path to backup.                                                                                                                                                                                                                                                                                                                                               |
| `RESTIC_BACKUP_ARGS`   | A space separated list of extra arguments to be passed to restic.                                                                                                                                                                                                                                                                                                                                                |
| `RETENTION_HOURS`     | Keep the last **x** hourly snapshots.                                                                                                                                                                                                                                                                                                                                  |
| `RETENTION_DAYS`     | Keep the last **x** daily snapshots.                                                                                                                                                                                                                                                                                                                                  |
| `RETENTION_WEEKS`     | Keep the last **x** weekly snapshots.                                                                                                                                                                                                                                                                                                                                           |
| `RETENTION_MONTHS`     | Keep the last **x** monthly snapshots.                                                                                                                                                                                                                                                                                                                                               |
| `RETENTION_YEARS`     | Keep the last **x** yearly snapshots.                                                                                                                                                                                                                                                                                                                                              |
