# Hoarder
> _a snippet collector_

##### gunicorn
The recommended amount of workers for gunicorn is __(2 x number_of_cores) +1__.

Find out your amount of cores with `nproc --all`.

example:
```bash
$ calc $(nproc --all)*2+1
  17
```

Little life hack to start gunicorn with correct amount of workers:
```bash
gunicorn -w $(calc $(nproc --all)*2+1) run:app
```
