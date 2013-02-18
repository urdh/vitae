SOURCES=$(wildcard *.tex)
TARGETS=$(SOURCES:.tex=.pdf)
.PHONY: all clean distclean
all: $(TARGETS)
clean:
	rm -f *.aux *.log *.out
distclean: clean
	rm -f *.pdf

%.pdf:
	xelatex $*.tex
	xelatex $*.tex
