REM build batch file for windows
echo *** starting build process ***
REM mkdocs build --clean
echo *** starting deploy process ***
echo git add --all && git commit -m "new deploy for gh-pages"
REM git subtree split --prefix site master
REM git push origin :gh-pages --force
echo *** success ***
