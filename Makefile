SUBMODULES := $(shell find shiny-server/ -mindepth 1 -maxdepth 1 -type d)

bump_metrics_submodule:
	for i in $(SUBMODULES); do cd $$i; git pull --ff-only; cd -;done
	git commit -m 'Bump metrics dashboard submodule' $(SUBMODULES)
	git review

update: git-update provision

git-update:
	git pull --ff-only
	git submodule update --init --recursive

provision: setup.sh
	sudo bash ./setup.sh
	sudo service shiny-server restart
	touch provision

