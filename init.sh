#!/usr/bin/env bash
echo -e "Lazy initializer for Flask development.\n"

NAME="hoarder"
DESCRIPTION="A snippet collector build in Flask."
DEBUG=false

echo -e "Building project ${NAME}\n\t${DESCRIPTION}.\n"

# install packages from package.list
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y $(awk '{print $1'} package.list)


# firewall rules with `ufw` if not allready enabled
if [[ $(sudo ufw status | grep 'Active') != 1 ]]; then
  sudo ufw allow ssh
  sudo ufw allow 'Nginx Full'
  sudo ufw enable
fi


if [ ${DEBUG} = true ]; then
  echo -e "Debug mode is on.\nRemoving existing database if existing.\n"
  if [ -f ${NAME}/snippets.db ]; then
    rm -rf ${NAME}/snippets.db
  fi
fi


# Setup virtualenv
if [ ! -d env ]; then
  echo -e "Initializing virtualenv for ${NAME}.\n"
  virtualenv -p /usr/bin/python3 env &>/dev/null
  env/bin/pip3 install -r requirements.txt &>/dev/null
  echo -e "Finished setting up virtualenv.\n"
fi


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
  if [ -f /etc/nginx/sites-enabled/default ]; then
    sudo rm -rf /etc/nginx/sites-enabled/default
  fi
  env/bin/python3 helper.py  # replaces IP_ADDR and CH_HOME in flask.conf
  sudo ln -s configs/nginx/flask.conf /etc/nginx/sites-enabled/
  env/bin/gunicorn -D -w $(($(nproc --all)*2+1)) app:app --chdir ${NAME}
  sudo systemctl enable nginx
  sudo systemctl restart nginx
fi
