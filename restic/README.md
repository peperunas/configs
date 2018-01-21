# Restic backup configs

Just create a `.env` file (its structure is defined below), **export** each variable and use the `call_restic` script to backup/clean a repository.

Make sure to edit the `ENV_FILES_PATH` in `call_restic` (and in the systemd unit files, if you use them)!

Feel free to browse a basic example: [`local.env`](./local.env).

## `.env` structure

| Name                | Description                                                                                                                                                                                                                                                                                                                                                                   |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `RESTIC_REPOSITORY` | The place **(remote)** where your backups will be saved                                                                                                                                                                                                                                                                                                                       |
| `RESTIC_PASSWORD`   | Your repository's password                                                                                                                                                                                                                                                                                                                                                    |
| `PATH_TO_BACKUP`    | Your **local** path to backup                                                                                                                                                                                                                                                                                                                                                 |
| `FORGET_TYPE`       | Defines how the remote snapshots should be purged when cleaning. The following `n` variable is defined by `FORGET_AMOUNT`. This field may be: "`l`" (**l**ast `n` snapshots), "`H`" (last `n` **H**ourly snapshots), "`d`"(last `n` **d**aily snapshots), "`w`" (last `n` **w**eekly snapshots), "`m`"(last `n` **m**onthly snapshots), "`y`" (last `n` **y**early snapshots) |
| `FORGET_AMOUNT`     | The number of snapshots to remove                                                                                                                                                                                                                                                                                                                                             |
If you use **AWS**, **BackBlaze**, etc, you might need to export some specific repository's variable! Just add them to your `.env` file.

## `.env` example file

An example is available [here](./local.env).

## systemd

In the `systemd/` folder there are the unit files I use to run my backups.

