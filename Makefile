
update:
	git pull --ff-only
	git submodule update --init --recursive
	sudo service shiny-server restart

provision:
	sudo bash -e ./setup.sh


