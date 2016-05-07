cn: main-cn.pdf
en: main-en.pdf

main-cn.pdf: main-cn.tex
	xelatex --file-line-error --synctex=1 main-cn
	open ./main-cn.pdf
	make clean

main-en.pdf: main-en.tex
	xelatex --file-line-error --synctex=1 main-en
	open ./main-en.pdf
	make clean

clean:
	rm -f *.aux *.log *.toc *.glo *.idx *.ilg *.out *.bbl *.thm *.blg *.lot *.lof *.synctex.gz
	touch main-en.tex
	touch main-cn.tex
