
bump_metrics_submodule:
	cd shiny-server/metrics
	git pull --ff-only
	git commit -m 'Bump metrics dashboard submodule' shiny-server/metrics
	git review

update:
	git pull --ff-only
	git submodule update --init --recursive
	sudo service shiny-server restart

provision:
	sudo bash -e ./setup.sh


