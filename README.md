# Discovery Dashboards

This is a collection of dashboards and tools for exploring aggregated Wikimedia search data. It contains everything from API usage to direct user interactions, and will only grow over time. The idea is that this will provide data for internal use and external use, to see how well we're doing.

## Running in Labs

Go to Special:NovaInstance on wikitech and start a new instance. The small instance with 2GB of memory is sufficient. Choose the image 'ubuntu-14.04-trusty' and click go. Wait for the instance to start, then login via SSH.

Follow [the instructions for setting up your instance with MediaWiki-Vagrant](https://wikitech.wikimedia.org/wiki/Help:MediaWiki-Vagrant_in_Labs#Setting_up_your_instance_with_MediaWiki-Vagrant). Specifically, add "role::labs::vagrant_lxc" and run `sudo puppet agent --test --verbose`

Log out and log back in.

```bash
sudo git clone https://gerrit.wikimedia.org/r/wikimedia/discovery/dashboard /srv/dashboards
cd /srv/dashboards
sudo git submodule update --init --recursive
sudo vagrant up
sudo chown -R mwvagrant .vagrant
vagrant up
```

**shiny-server** should now be running on port 3838. To make this
available to the world visit Special:NovaProxy in wikitech. Point a
subdomain at the instance and make sure to port 3838 as the instance
port.

### Updating

Perform this step after merging a patch:

```bash
sudo make update
```

### Manually restarting Shiny Server

```
$> mwvagrant ssh
ssh> sudo service shiny-server restart
```

## Running on your machine

Download and install [Vagrant](https://www.vagrantup.com/downloads.html) & [VirtualBox](https://www.virtualbox.org/wiki/Downloads). Then clone the repo, initialize the submodules, and `vagrant up`

## Dashboards as submodules

All of the following is done on your local clone of this repo:

### Adding

```bash
git submodule add <URL to repo>.git shiny-server/<name>
git submodule update --init --recursive
```

### Updating the dashboards in this repository

This repository contains only the code that wraps around and
provisions the dashboards, not the dashboard itself. The dashboards
are kept as git submodules. To point the submodules at the latest
versions, use the following command:

```bash
git submodule foreach git pull origin master
```

Please remember to describe the changes in [CHANGELOG.md](CHANGELOG.md), then:

```bash
git add -A
git commit -m "Updating dashboards..."
git review
<git add -A && git commit --amend && git review>
```

## Additional information

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

### Maintainers

- [Erik Bernhardson](https://meta.wikimedia.org/wiki/User:EBernhardson_(WMF))
- [Oliver Keyes](https://meta.wikimedia.org/wiki/User:Okeyes_(WMF))
- [Mikhail Popov](https://meta.wikimedia.org/wiki/User:MPopov_(WMF))
