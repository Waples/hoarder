# Hoarder
> _a snippet collector_

## Why?
I'm learning about Flask and Frontend/Backend, this is my ongoing learning project.
__Hoarder__ is a cruddy snippet collector using `Flask` and `SQLAlchemy` (with `sqlite3`).

You can run `./init.sh` to check it out yourself.

#### nginx & gunicorn (ToDo)
I'm gonna run this app on my **RPi3B+** at home, using nginx and gunicorn ('cause I got to learn that too :P).
Basic configs for nginx and gunicorn are found under `configs/` respectively.

##### gunicorn
The recommended amount of workers for gunicorn is __(2 x number_of_cores) +1__.

Find out your amount of cores with `nproc --all`.

Little life hack to start gunicorn with correct amount of workers:
```bash
env/bin/gunicorn -w $(calc $(nproc --all)*2+1) app:app --chdir ${NAME}
```
