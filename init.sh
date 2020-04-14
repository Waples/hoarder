#!/usr/bin/env bash
echo -e "Lazy initializer for Flask development.\n"

NAME="Hoarder"
DESCRIPTION="A snippet collector build in Flask."

echo -e "Building project ${NAME}\n\t${DESCRIPTION}.\n"


# Set debug mode (default: False).
DEBUG=true
if [ ${DEBUG} = true ]; then
  echo -e "Debug mode is on.\nRemoving existing database if existing.\n"
  if [ -f hoarder/snippets.db ]; then
    rm -rf hoarder/snippets.db
  fi
fi


# Setup virtualenv
echo -e "Initializing virtualenv for ${NAME}.\n"
virtualenv env &>/dev/null
env/bin/pip3 install -r requirements.txt &>/dev/null
echo -e "Finished setting up virtualenv.\n"


# (Re)Create database if not present.
if [ ! -f hoarder/snippets.db ]; then
  source env/bin/activate
  echo -e "Creating local database."
  env/bin/python create_db.py &>/dev/null
fi


# if debug, start the development server, else start gunicorn & nginx.
if [ ${DEBUG} = true ]; then
  echo -e "Starting development server at localhost:5000.\n"
  env/bin/python3 hoarder/app.py
else
  echo -e "TODO: start gunicorn & nginx and stuffs..."
  env/bin/python3 hoarder/app.py
fi
