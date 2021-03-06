#!/bin/bash

set -e

if [ "$(whoami)" != "root" ]; then
  echo
  echo "This script must be run as root:"
  echo "  sudo bash $0 $*"
  echo
  exit 1
fi

realpath() {
  # realpath is not installed by default in ubuntu :(
  # mimic it here
  echo "
import os
print os.path.realpath('$1')
" | python
}

RESTART_SHINY=0
if [ -d /vagrant ]; then
  export PROJECT_ROOT=/vagrant
else
  export PROJECT_ROOT=$(realpath $(dirname $0))
fi
export WEB_ROOT=$PROJECT_ROOT/shiny-server
export LOG_ROOT=$PROJECT_ROOT/log

install_r_package() {
  local TARGET="/usr/local/lib/R/site-library/$1"
  if [ ! -d "$TARGET" ]; then
    /usr/bin/R -e "install.packages('$1', repos='https://cran.rstudio.com')"
    test -d $TARGET
    RESTART_SHINY=1
  fi
}
# This requires the devtools package so for all that's good and beautiful
# in the world do not put a call to it in a line before install_r_package devtools.
git_install_r_package() {
  local PKG=$(echo $1 | sed 's=.*/\(.*\)$=\1=')
  local TARGET="/usr/local/lib/R/site-library/${PKG}"
  if [ ! -d "$TARGET" ]; then
    /usr/bin/R -e "devtools::install_git('$1', dependencies = TRUE, lib = '/usr/local/lib/R/site-library')"
    test -d $TARGET
    RESTART_SHINY=1
  fi
}
github_install_r_package() {
  local PKG=$(echo $1 | sed 's=.*/\(.*\)$=\1=')
  local TARGET="/usr/local/lib/R/site-library/${PKG}"
  if [ ! -d "$TARGET" ]; then
    /usr/bin/R -e "devtools::install_github('$1', dependencies = TRUE, lib = '/usr/local/lib/R/site-library'); q(save = 'no')"
    test -d $TARGET
    RESTART_SHINY=1
  fi
}

update_r_package() {
  /usr/bin/R -e "devtools::update_packages('$1')"
}

install_dist_template() {
  local PROCESSED="/tmp/install_dist_templates.$$"
  envsubst < $1 > $PROCESSED
  install_dist_file $PROCESSED $2
  rm -f $PROCESSED
}

install_dist_file() {
  local SOURCE="$1"
  local SOURCE_MD5=$(md5sum "$SOURCE" | cut -d ' ' -f 1)

  local DEST="$2"
  if [ -f "$DEST" ]; then
    local DEST_MD5=$(md5sum "$DEST" | cut -d ' ' -f 1)
  else
    local DEST_MD5=""
  fi
  if [ "$SOURCE_MD5" = "$DEST_MD5" ]; then
    INSTALL_DIST_FILE_STATE="exists"
  else
    cp $SOURCE $DEST
    INSTALL_DIST_FILE_STATE="installed"
  fi
}

download_file() {
  local DEST="$1/$2"
  local URL="$3/$2"
  if [ ! -f "$DEST" ]; then
    curl "$URL" -o "$DEST"
  fi
}

{
  if [ -d /vagrant/cache/apt -a ! -h /var/cache/apt/archives ]; then
    rm -rf /var/cache/apt/archives
    ln -s /vagrant/cache/apt /var/cache/apt/archives
  fi

  echo "Installing apt repositories..."
  apt-get -y install gettext
  install_dist_template \
      $PROJECT_ROOT/files/etc_apt_sources.list.d_rproject.list \
      /etc/apt/sources.list.d/rproject.list
  if [ "$INSTALL_DIST_FILE_STATE" = "installed" ]; then
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
  fi
  if [ "$INSTALL_DIST_FILE_STATE" = "installed" -o "$SKIP_APT_UPDATE" != "1" ]; then
    echo "Updating APT..."
    apt-get update
  fi
  
  echo "Upgrading installed software packages..."
  apt-get -y upgrade

  echo "Installing packages..."
  apt-get -y install gfortran libssl-dev libcurl4-openssl-dev libxml2-dev libssh2-1-dev libcairo2-dev \
    git-core gdebi r-base r-base-dev r-recommended

  echo "Installing R packages..."
  # Necessities:
  install_r_package shiny
  install_r_package xml2
  install_r_package rvest
  install_r_package curl
  install_r_package devtools
  install_r_package countrycode
  # ^ Needed for installation from Git
  # Data manipulation packages:
  install_r_package data.table
  install_r_package readr
  install_r_package reshape2
  install_r_package plyr
  install_r_package lubridate
  install_r_package toOrdinal
  install_r_package magrittr
  install_r_package tidyverse
  install_r_package assertthat
  install_r_package zoo
  # Data visualization & reporting packages:
  install_r_package dygraphs
  install_r_package RColorBrewer
  install_r_package ggvis
  install_r_package ggthemes
  install_r_package DT
  install_r_package sparkline
  install_r_package highcharter
  # Reporting and dashboarding:
  install_r_package rmarkdown
  install_r_package knitr
  install_r_package shinydashboard
  install_r_package flexdashboard
  install_r_package shinyjs
  github_install_r_package jcheng5/googleCharts
  git_install_r_package https://gerrit.wikimedia.org/r/wikimedia/discovery/polloi
  
  echo "Updating installed R packages..."
  update_r_package polloi
  update_r_package shiny
  update_r_package shinydashboard

  echo "Installing shiny-server..."
  if [ ! -d /opt/shiny-server ]; then
    PACKAGE="shiny-server-1.4.6.809-amd64.deb"
    # See https://www.rstudio.com/products/shiny/download-server/ for latest version.
    download_file /root $PACKAGE http://download3.rstudio.org/ubuntu-12.04/x86_64
    gdebi -n "/root/$PACKAGE"
  fi

  echo "Configuring shiny-server..."
  install_dist_template \
      $PROJECT_ROOT/files/etc_shiny-server_shiny-server.conf \
      /etc/shiny-server/shiny-server.conf
  if [ "$INSTALL_DIST_FILE_STATE" = "installed" ]; then
    RESTART_SHINY=1
  fi

  echo "Setting up init scripts..."
  if [ -f /etc/init/shiny-server.conf ]; then
    install_dist_template \
        $PROJECT_ROOT/files/etc_init_shiny-server.conf \
        /etc/init/shiny-server.conf
    service shiny-server restart
  elif [ -d /etc/systemd/system ]; then
    rm -f /etc/init.d/shiny-server
    install_dist_file \
        $PROJECT_ROOT/files/etc_systemd_system_shiny-server.service \
        /etc/systemd/system/shiny-server.service
    systemctl daemon-reload
    systemctl enable shiny-server.service
    systemctl start shiny-server.service
  else
    install_dist_file \
        $PROJECT_ROOT/files/etc_init.d_shiny-server \
        /etc/init.d/shiny-server
    chmod +x /etc/init.d/shiny-server
  fi

  if [ "$RESTART_SHINY" -eq 1 ]; then
    service shiny-server restart
  fi

  echo
  echo Done.
  echo
} 2>&1 | while read line; do
  echo "[$(date -R)]  $line"
done
