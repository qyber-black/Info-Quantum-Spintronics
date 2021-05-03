#!/bin/bash

set -e

if [ -z "${WIKI_PERSONAL_ACCESS_TOKEN}" ]; then
  echo "WIKI_PERSONAL_ACCESS_TOKEN not set"
  exit 1
fi

echo
echo "# Cloning github wiki"
git clone "https://${WIKI_PERSONAL_ACCESS_TOKEN}@${GITHUB_SERVER_URL#https://}/$GITHUB_REPOSITORY.wiki.git"
wiki_dir="`basename $GITHUB_REPOSITORY.wiki`"

echo
echo "# Sync'ing with qyber wiki"
cd "$wiki_dir"
git remote add qyber https://qyber.black/quantum-spintronics/info-quantum-spintronics.wiki.git
git config --global user.email "frank@langbein.org"
git config --global user.name "Frank C Langbein (via github actions)"
git config pull.rebase true
git fetch qyber master
git rebase qyber/master
git pull
cd ..

echo
echo "# Update paper"
curl -s https://d.qyber.black/paper/quantum-spintronics-paper-ingaas-spin-transport/paper.pdf --output paper.pdf
if ! diff -q paper.pdf "$wiki_dir/paper/quantum-spintronics-paper-ingaas-spin-transport.pdf"; then
  echo "## PDFs are different"
  cd "$wiki_dir"
  mv ../paper.pdf paper/quantum-spintronics-paper-ingaas-spin-transport.pdf
  git add paper/quantum-spintronics-paper-ingaas-spin-transport.pdf
  git commit -m "Automatically updated paper/quantum-spintronics-paper-ingaas-spin-transport.pdf"
  cd ..
fi

echo
echo "# Update wiki"
cd "$wiki_dir"
git push
