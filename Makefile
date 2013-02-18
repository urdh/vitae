.PHONY: cv all clean distclean
cv: svenska.pdf english.pdf
all: cv letters
clean:
	rm -f *.aux *.log *.out
distclean: clean
	rm -f *.pdf

%.pdf:
	sh ./vc
	xelatex $*.tex
	xelatex $*.tex

letters:
	$(MAKE) -C letters;
