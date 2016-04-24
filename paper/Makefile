cn: main-cn.pdf
en: main-en.pdf

main-cn.pdf: main-cn.tex content/*
	latexmk -xelatex main-cn
	make clean

main-en.pdf: main-en.tex content/*
	latexmk -xelatex main-en
	make clean

clean:
	rm -f *.fdb_latexmk *.fls content/*.aux content-en/*.aux *.aux *.log *.toc *.glo *.idx *.ilg *.out *.bbl *.thm *.blg *.lot *.lof *.synctex.gz
	touch main-en.tex
	touch main-cn.tex
