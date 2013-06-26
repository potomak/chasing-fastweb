love=/usr/bin/love
zip=/usr/bin/zip
luac=/usr/bin/luac

builddir=build
distdir=dist

windir=~/Downloads/love-0.8.0-win-x86
osxapp=~/Downloads/love.app

company=potomak
game=chasing_fastweb
sources=*.lua **/*.lua
res=assets/*.png assets/*.gif assets/*.ttf

.PHONY : run test love clean win

run : test
	$(love) .

test :
	$(luac) -p $(sources)

dist : love win osx

love : $(builddir)/$(game).love
	cp $(builddir)/$(game).love $(distdir)/$(game).love

osx : $(builddir)/$(game).app
	cd $(builddir); \
		zip -9 -q -r ../$(distdir)/$(game).osx.zip $(game).app

win : $(builddir)/$(game).exe
	cd $(builddir); \
		cp $(windir)/*.dll .; \
		zip -q ../$(distdir)/$(game).win.zip $(game).exe *.dll; \
		rm *.dll

$(builddir)/$(game).app : $(builddir)/$(game).love
	cp -a $(osxapp) $(builddir)/$(game).app
	cp $(builddir)/$(game).love $(builddir)/$(game).app/Contents/Resources/
	sed -i.bak 's/<string>LÖVE<\/string>/<string>$(game)<\/string>/g' "$(builddir)/$(game).app/Contents/Info.plist"
	sed -i.bak 's/<string>org\.love2d\.love<\/string>/<string>org\.$(company)\.$(game)<\/string>/g' "$(builddir)/$(game).app/Contents/Info.plist"
	sed -i.bak '/<key>UTExportedTypeDeclarations<\/key>/,/^\t<\/array>/{d}' "$(builddir)/$(game).app/Contents/Info.plist"

$(builddir)/$(game).exe : $(builddir)/$(game).love
	cat $(windir)/love.exe $(builddir)/$(game).love > $(builddir)/$(game).exe

$(builddir)/$(game).love : $(sources) $(res)
	mkdir -p $(builddir)
	mkdir -p $(distdir)
	$(zip) $(builddir)/$(game).love $(sources) $(res)

clean :
	rm -rf $(builddir)/* $(distdir)/*