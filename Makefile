.PHONY: cv all clean distclean letters deploy
cv: svenska.pdf english.pdf
all: cv letters
clean:
	rm -f *.aux *.log *.out
	$(MAKE) -C letters clean
distclean: clean
	rm -f *.pdf
	$(MAKE) -C letters distclean

%.pdf: %.tex skvitae.cls
	sh ./vc -f -m
	xelatex $<
	xelatex $<

letters:
	$(MAKE) -C letters
