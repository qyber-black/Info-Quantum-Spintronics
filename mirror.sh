#!/bin/bash

set -e

if [ -z "${WIKI_PERSONAL_ACCESS_TOKEN}" ]; then
  echo "WIKI_PERSONAL_ACCESS_TOKEN not set"
  exit 1
fi

echo "# Cloning github wiki"
git clone "https://${WIKI_PERSONAL_ACCESS_TOKEN}@${GITHUB_SERVER_URL#https://}/$GITHUB_REPOSITORY.wiki.git"
cd "`basename $GITHUB_REPOSITORY.wiki`"

echo "# Rebasing qyber wiki"
git remote add qyber https://qyber.black/quantum-spintronics/info-quantum-spintronics.wiki.git
git config --global user.email "frank@langbein.org"
git config --global user.name "Frank C Langbein (via github actions)"
git config pull.rebase true
git fetch qyber master
git rebase qyber/master
git pull

echo "# Update paper"
curl https://d.qyber.black/paper/quantum-spintronics-paper-ingaas-spin-transport/paper.pdf --output paper.pdf
if ! diff paper.pdf Info-Quantum-Spintronics.wiki/paper/quantum-spintronics-paper-ingaas-spin-transport.pdf; then
  echo "## PDFs are different"
  mv paper.pdf Info-Quantum-Spintronics.wiki/paper/quantum-spintronics-paper-ingaas-spin-transport.pdf
  cd Info-Quantum-Spintronics.wiki
  git add paper/quantum-spintronics-paper-ingaas-spin-transport.pdf
  git commit -m "Automatically updated paper/quantum-spintronics-paper-ingaas-spin-transport.pdf"
fi

echo "# Update wiki"
git push
