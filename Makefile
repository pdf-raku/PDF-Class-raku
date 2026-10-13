DocProj=pdf-raku.github.io
DocRepo=https://github.com/pdf-raku/$(DocProj)
DocLinker=../$(DocProj)/etc/resolve-links.raku
RefMaker=etc/make-quick-ref.raku
TEST_JOBS ?= 8

POD = $(shell find lib -name \*.rakumod|xargs grep -le '\(#=\)\|\(=begin\)')
MD = $(subst lib/,docs/,$(patsubst %.rakumod,%.md,$(POD)))

all : md

test :
	prove6 -I . -j $(TEST_JOBS) t

loudtest :
	@prove6 -I . -v t

clean :
	@rm -f `find docs -name \*.md`

previews : test
	@raku -M PDF::To::Cairo -c
	@raku -M FontConfig -c
	pdf-previews tmp

$(MD): docs/%.md: lib/%.rakumod
	@raku -I . -c $<
	@mkdir -p `dirname $@`
	raku -I . --doc=Markdown $< \
	| TRAIL=$* raku -p -n $(DocLinker) \
        > $@

docs/index.md : README.md
	cp $< $@

# note: need to uncomment temporarily uncomment
# 'use PDF::ISO_32000' ... 'also does PDF::ISO_32000'
# these have been taken out of the dist due to
# resource usage (open files).
readme :
	@raku -I . $(RefMaker) README.md > README.tmp;
	@mv README.tmp README.md;

$(DocLinker) :
	(cd .. && git clone $(DocRepo) $(DocProj))

Pod-To-Markdown-installed :
	@raku -M Pod::To::Markdown -c

md : previews $(DocLinker) Pod-To-Markdown-installed $(MD)

doc : previews md readme docs/index.md
