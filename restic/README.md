# Restic backup configs

Just create a `.env` file and use the `call_restic` script to execute/clean a repository.

Make sure to edit the `ENV_FILES_PATH` in `call_restic` (and in the systemd unit files, if you use them)!

## systemd

In the `systemd/` folder there are the unit files I use to run my backups.
