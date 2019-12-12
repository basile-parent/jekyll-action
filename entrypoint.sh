#!/bin/bash
set -e

echo "#################################################"
echo "Starting the Jekyll Action"

bundle install
echo "#################################################"
echo "Installion completed"

if [[ -z "${SRC}" ]]; then
  SRC=$(find . -name _config.yml -exec dirname {} \;)
fi

echo "#################################################"
echo "Source for the Jekyll site is set to ${SRC}"

bundle exec jekyll build -s ${SRC} -d build
echo "#################################################"
echo "Jekyll build done"

cd build

# No need to have GitHub Pages to run Jekyll
touch .nojekyll

echo "#################################################"
echo "Now publishing"

echo secrets : ${{ secrets.JEKYLL_PAT }}
TOKEN=${{secrets.JEKYLL_PAT}}

remote_repo="https://${TOKEN}@github.com/${GITHUB_REPOSITORY}.git" && \
remote_branch="master" && \
git init && \
git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
git add . && \
git commit -m 'jekyll build from Action' && \
git push --force $remote_repo master:$remote_branch && \
rm -fr .git && \
cd ..
