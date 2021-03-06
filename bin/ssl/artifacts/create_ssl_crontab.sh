#!/bin/sh

read_var() {
    VAR=$(grep $1 $2 | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    echo ${VAR[1]}
}

if test -f ".env"; 
then
  SSL_CHORDS_DIR=$(read_var SSL_CHORDS_DIR .env)
else
    echo ".env not found in current directory"
fi

if [ -z ${SSL_CHORDS_DIR+x} ]; 
then 
  echo "SSL_CHORDS_DIR is unset"; 
  abort="true"
fi

if [[ $abort = "true" ]]
then
  echo "\naborting...\n"
else
  #write out current crontab
  crontab -l > /tmp/ssl_cron

  #echo new cron into cron file
  sudo touch ${SSL_CHORDS_DIR}/log/cron.log
  sudo chmod 666 ${SSL_CHORDS_DIR}/log/cron.log

  # echo "*/5 * * * * ${SSL_CHORDS_DIR}/bin/ssl/renew_ssl_cert.sh >> ${SSL_CHORDS_DIR}/log/cron.log 2>&1" >> /tmp/ssl_cron
  echo "15 3 * * * cd ${SSL_CHORDS_DIR}  ; ${SSL_CHORDS_DIR}/bin/ssl/renew_ssl_cert.sh >> ${SSL_CHORDS_DIR}/log/cron.log 2>&1" >> /tmp/ssl_cron

  #install new cron file
  crontab /tmp/ssl_cron

  rm /tmp/ssl_cron
fi
