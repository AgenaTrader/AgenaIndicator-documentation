#!/bin/bash
# This shell script will build and deploy everything from this repository.
# Simon Pucher 28.07.2016

if [ "$1" = "" ] ; then
   echo "No parameter was specified or parameter unknown, so I do not know what to do and I am going to exit now!"
   exit
fi

# echo "$1"
if [ "$1" = "-b" ] ;
then
  # echo "let's build"

  # variables
  TODAY=$(date)

  # change the creation date of the ebook
  cd documents
  sed -e "s%.*date.*%date: $TODAY%g" epub_title.txt > epub_title.txt.bak && rm epub_title.txt && mv epub_title.txt.bak epub_title.txt
  cd ..

  # build epub ebook with pandoc
  cd sources
  pandoc -S --epub-cover-image=../documents/epub_cover.png --epub-stylesheet=../documents/epub_styles.css -o ../documents/agenaindicator-documentation.epub ../documents/epub_title.txt index.md data.md indicators_oscillators.md
  cd ..

  # build word file with pandoc
  # pandoc -S -o ../documents/agenaindicator-documentation.docx ../documents/epub_title.txt index.md data.md indicators_oscillators.md

  # build new static sites via mkdocs
  mkdocs build --clean

  exit
elif [ "$1" = "-d" ] ;
then
  # echo "let's deploy"

  # if anything in the site/subdirectory changed in the prior commit,
  # push that directory to gh-pages for auto generation.
  git diff-tree -r --name-only --no-commit-id master | grep '^site/' &> /dev/null
  if [ $? == 0 ]; then
    git push origin `git subtree split --prefix site master 2> /dev/null`:gh-pages --force
    # merge master
    # git commit -a -m "Automatic deploy: $TODAY"
  else
    echo "No deploy was done and I am going to exit now!"
    exit
  fi

  exit
fi
