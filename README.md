# Discovery Dashboards

This is a collection of dashboards and tools for exploring aggregated Wikimedia search data. It contains everything from API usage to direct user interactions, and will only grow over time. The idea is that this will provide data for internal use and external use, to see how well we're doing.

## Running in labs

Go to Special:NovaInstance on wikitech and start a new instance. The
The small instance with 2GB of memory is sufficient. Leave the image
type at the default of 'debian-8.1-jessie' and click go. Wait for
the instance to start, then login via ssh.

First we need to clone the repository:

```
$ sudo git clone https://gerrit.wikimedia.org/r/wikimedia/discovery/dashboard /srv/dashboards
```

Then we need to provision everything:

```
$ sudo bash /srv/dashboards/setup.sh
```

**shiny-server** should now be running on port 3838. To make this
available to the world visit Special:NovaProxy in wikitech. Point a
subdomain at the instance and make sure to port 3838 as the instance
port.

### Updating

Perform this step after merging a patch:

```
$ sudo make update
```

### Manually restarting Shiny Server

```
$ mwvagrant ssh
$ sudo service shiny-server restart
```

## Running on your machine

```
$ vagrant up
```

## Dashboards as submodules

All of the following is done on your local clone of this repo:

### Adding

```
$ git submodule add <URL to repo>.git shiny-server/<name>
$ git submodule update --init --recursive
```

### Updating the dashboards in this repository

This repository contains only the code that wraps around and
provisions the dashboards, not the dashboard itself. The dashboards
are kept as git submodules. To point the submodules at the latest
versions, use the following command:

```
$ git submodule foreach git pull origin master
```

Please remember to describe the changes in [CHANGELOG.md](CHANGELOG.md), then:

```
$ git add -A
$ git commit -m "Updating dashboards..."
$ git review
$ <git add -A && git commit --amend && git review>
```

## Additional information

Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

### Maintainers

- [Erik Bernhardson](https://meta.wikimedia.org/wiki/User:EBernhardson_(WMF))
- [Oliver Keyes](https://meta.wikimedia.org/wiki/User:Okeyes_(WMF))
- [Mikhail Popov](https://meta.wikimedia.org/wiki/User:MPopov_(WMF))
