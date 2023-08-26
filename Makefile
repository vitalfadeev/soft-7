all:
	dub run

release:
	dub build --arch=x86_64  --compiler=ldc2.exe  --build=release

git:
	# git init
	# git branch -M main
	# git remote add origin git@github.com:vitalfadeev/soft-6.git
	git add -A .
	git commit -m "upd"
	git push -u origin main

clean:
	rmdir /Q /S .dub
	del /Q *.exe
	del /Q *.pdb
	del /Q mixins.d
	del /Q dub.selections.json