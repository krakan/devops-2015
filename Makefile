parts = devops-2015

pdfs = $(addsuffix .pdf,$(parts))
print = $(addsuffix -print.pdf,$(parts))

html = $(addsuffix .html,$(parts))
css = $(addsuffix .css,$(parts))

all: $(html)
handout: $(print)

%.pdf: %.txt styles/presentation.style
	LC_ALL=sv_SE.UTF-8 rst2pdf --break-level=1 -sstyles/presentation -skerning --smart-quotes 2 $<

%.html: %.txt $(css)
	LC_ALL=sv_SE.UTF-8 rst2s5 --link-stylesheet --stylesheet=$(css) --smart-quotes=yes --current-slide $< $@
	perl -pi -e 's%<div class="layout">%<div class="layout">\n<img id="slant" src="img/slant.png">%' $@

index.html: $(html)
	cp $< $@

%-print.pdf: %.pdf
	./twoup.sh $?

publish: $(html) $(css) img ui index.html
	@sshadd
	rsync -ztvua --delete --progress $? lekstugan:/var/www/jonas.init.se/htdocs/devops-2015/
