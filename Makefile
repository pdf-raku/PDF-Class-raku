DocProj=pdf-raku.github.io
DocRepo=https://github.com/pdf-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku

POD = $(shell find lib -name \*.rakumod|xargs grep -le '=begin')
MD = $(subst lib/,docs/,$(patsubst %.rakumod,%.md,$(POD)))

all : doc

doc : test
	@raku -M PDF::To::Cairo -c
	pdf-previews.raku tmp

test :
	prove6 -I . t

loudtest :
	@prove6 -I . -v t

clean :
	@rm -f `find docs -name \*.md`

$(MD): docs/%.md: lib/%.rakumod
	@raku -I . -c $<
	@mkdir -p `dirname $@`
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n $(DocLinker) \
        > $@

docs/index.md : README.md
	cp $< $@

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

Pod-To-Markdown-installed :
	@raku -M Pod::To::Markdown -c

doc :  $(DocLinker) Pod-To-Markdown-installed $(MD) docs/index.md
