#!/bin/bash

set -e

echo "# Cloning github wiki"
git clone https://github.com/xis10z/Info-Quantum-Spintronics.wiki.git
cd Info-Quantum-Spintronics.wiki

echo "# Rebasing qyber wiki"
git remote add qyber https://qyber.black/quantum-spintronics/info-quantum-spintronics.wiki.git
git config --global user.email "frank@langbein.org"
git config --global user.name "Frank Langbein (on github)"
git fetch qyber master
git rebase qyber/master

echo "# Push any changes"
git pull
git push
