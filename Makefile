index: Main.elm
	#elm-format Main.elm --yes
	elm-make Main.elm --output elm.js

.PHONY: clean

clean: 
	rm elm.js
