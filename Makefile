DocProj=pdf-raku.github.io
DocRepo=https://github.com/pdf-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku
RefMaker=etc/make-quick-ref.raku
TEST_JOBS ?= 8

POD = $(shell find lib -name \*.rakumod|xargs grep -le '=begin')
MD = $(subst lib/,docs/,$(patsubst %.rakumod,%.md,$(POD)))

all : doc

test :
	prove6 -I . -j $(TEST_JOBS) t

loudtest :
	@prove6 -I . -v t

clean :
	@rm -f `find docs -name \*.md`

previews : test
	@raku -M PDF::To::Cairo -c
	@raku -M FontConfig -c
	pdf-previews.raku tmp

$(MD): docs/%.md: lib/%.rakumod
	@raku -I . -c $<
	@mkdir -p `dirname $@`
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n $(DocLinker) \
        > $@

docs/index.md : README.md
	cp $< $@

doc-refs :
	@raku -I . $(RefMaker) README.md > README.tmp;
	@mv README.tmp README.md;

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

Pod-To-Markdown-installed :
	@raku -M Pod::To::Markdown -c

doc : previews $(DocLinker) Pod-To-Markdown-installed $(MD) docs/index.md doc-refs
