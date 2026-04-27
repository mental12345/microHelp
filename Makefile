.PHONY: install setup createdocs

setup:
	mkdir -p ${HOME}/.config/micro/plug/microHelp

createdocs:
	mkdir -p ${HOME}/microDocs
	cp -r docs/* ${HOME}/microDocs/

install: setup createdocs
	cp -r * ${HOME}/.config/micro/plug/microHelp/
