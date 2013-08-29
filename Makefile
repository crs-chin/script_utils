default:install

install:
	install -D -m 755 stateind.sh ~/bin/stateind.sh
	install -D -m 755 colortbl.sh ~/bin/colortbl.sh
	install -D -m 755 renderit  ~/bin/renderit
	install -D -m 644 renderit.awk ~/.renderit/renderit.awk

.PHONY:install

