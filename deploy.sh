## this script deploys the static website of course.rs to github pages

## build static website for book  并且执行 del-searcher-js
mdbook build && ./del-searcher-js.sh

## init git repo
cd book
git init
git config user.name "Labyte"
git config user.email "abytegg@gmail.com"
git add .
git commit -m 'deploy'
git branch -M gh-pages
git remote add origin https://github.com/labyte/book

## push to github pages
git push -u -f origin gh-pages