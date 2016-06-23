# Change Log (Patch Notes)
All notable changes to the *Discovery Dashboards* project will be documented in this file.

## 2016/06/23
- Deployed a new version of Portal dashboard that includes clickthrough rates
  of first visits only.

## 2016/04/05
- Deployed Portal and External Traffic dashboard versions that are
  compatible with the new data format. [T130083](https://phabricator.wikimedia.org/T130083)

## 2016/03/04
- Deployed Maps dashboard with geo breakdown
- Deployed Portal dashboard with external referral breakdown
- Added 'wmf' R package to list of installed R packages

## 2016/02/19
- Deployed Portal dashboard ft. browser breakdown and pageviews
  - Also added sharing settings via URL and smoothing features
- Deployed Search Metrics dashboard ft. zero results rate breakdown by
  language and project pairs
- Deployed Maps dashboard with URL sharing
- Deployed External Traffic dashboard with fixed bugs

## 2016/01/20
- Deployed new, more robust Metrics dashboard version
- Deployed Maps dashboard with new annotations

## 2016/01/19
- Deployed Portal dashboard that includes geo graphs

## 2015/12/14
- Deploying WDQS dashboard that includes bot filtering for usage data
- Deploying URL updaters across all dashboards

## 2015/11/30
- Deploying a new dashboard for visualizing Portal usage.

## 2015/11/18
- Deploying a new version of each dashboard that includes a notification
  system for missing data.

## 2015/11/05
- Deploying Search Metrics dashboard with time frame selection
  and updated (fixed) KPI date range functionality.

## 2015/10/27
- Added external referral traffic dashboard
- Fixed the bug with installing R packages from a git repo

## 2015/10/15
- Expanded the dashboard index to link to the main Discovery team page

## 2015/10/07
- Updated Maps dash to have tile usage data.

## 2015/10/05
- Search Metrics dash now has user engagement metrics.

## 2015/09/30
- Added a change log
- Added a Contributor Code of Conduct
- Updated **setup.sh**:
	- ...to install *libxml2-dev* & *libssh2-1-dev* (required for some of the R packages)
	- ...to conclude with `q(save = 'no')` when installing R packages
- Updated and reformatted the readme

## 2015/09/29
- Updated Metrics dash to [include user engagement & survival analysis metrics](https://gerrit.wikimedia.org/r/241115)
- Updated WDQS dash to [have a proper title in the web browser](https://gerrit.wikimedia.org/r/#/c/241119/)
- Updated Maps dash to [have a proper title in the web browser](https://gerrit.wikimedia.org/r/#/c/241120/)
