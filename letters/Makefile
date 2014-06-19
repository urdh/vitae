SOURCES=$(wildcard *.tex)
TARGETS=$(SOURCES:.tex=.pdf)
.PHONY: all clean distclean 2013 2014
all: $(TARGETS) 2013 2014
clean:
	rm -f *.aux *.log *.out
	$(MAKE) -C 2013 clean
	$(MAKE) -C 2014 clean
distclean: clean
	rm -f *.pdf
	$(MAKE) -C 2013 distclean
	$(MAKE) -C 2014 distclean

%.pdf: %.tex
	xelatex $<
	xelatex $<

2013:
	$(MAKE) -C 2013
2014:
	$(MAKE) -C 2014
