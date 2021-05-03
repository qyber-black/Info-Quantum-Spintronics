#!/bin/bash

set -e

echo "# Cloning github wiki"
git clone git@github.com:xis10z/Info-Quantum-Spintronics.wiki.git
cd Info-Quantum-Spintronics.wiki

echo "# Rebasing qyber wiki"
git remote add qyber git@qyber.black:quantum-spintronics/info-quantum-spintronics.wiki.git
git fetch qyber master
git rebase qyber/master

echo "# Push any changes"
git pull
git push