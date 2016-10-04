REM build batch file for windows
echo *** starting build process ***
mkdocs build --clean
echo *** starting deploy process ***
git subtree split --prefix site master
git push origin :gh-pages --force
echo *** success ***
