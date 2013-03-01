.PHONY: cv all clean distclean letters
cv: svenska.pdf english.pdf
all: cv letters
clean:
	rm -f *.aux *.log *.out
	$(MAKE) -C letters clean
distclean: clean
	rm -f *.pdf
	$(MAKE) -C letters distclean

%.pdf:
	sh ./vc
	xelatex $*.tex
	xelatex $*.tex

letters:
	$(MAKE) -C letters
