#!/usr/bin/env bash
echo -e "Lazy initializer for Flask development.\n"

NAME="hoarder"
DESCRIPTION="A snippet collector build in Flask."
DEBUG=true

echo -e "Building project ${NAME}\n\t${DESCRIPTION}.\n"

if [ ${DEBUG} = true ]; then
  echo -e "Debug mode is on.\nRemoving existing database if existing.\n"
  if [ -f ${NAME}/snippets.db ]; then
    rm -rf ${NAME}/snippets.db
  fi
fi


# Setup virtualenv
echo -e "Initializing virtualenv for ${NAME}.\n"
virtualenv -p /usr/bin/python3 env &>/dev/null
env/bin/pip3 install -r requirements.txt &>/dev/null
echo -e "Finished setting up virtualenv.\n"


# (Re)Create database if not present.
if [ ! -f ${NAME}/snippets.db ]; then
  source env/bin/activate
  echo -e "Creating local database."
  env/bin/python3 create_db.py &>/dev/null
fi


# if debug, start the development server, else start gunicorn & nginx.
if [ ${DEBUG} = true ]; then
  env/bin/python3 ${NAME}/app.py
else
  env/bin/python3 helper.py  # replaces IP_ADDR in configs/nginx/flask.conf
  env/bin/gunicorn -w $(calc $(nproc --all)*2+1) app:app --chdir ${NAME}
fi
