#!/usr/bin/env bash
# Déploie le site sur GitHub Pages (tabsuspender.app).
# Usage :  ./deploy.sh ["message de commit"]
set -e
cd "$(dirname "$0")"

REPO="https://github.com/elouarzaziomar-lab/tab-suspender.git"
MSG="${1:-Update site}"

# Première fois : initialise le dépôt et adopte l'historique distant
# (git reset --soft ne touche PAS aux fichiers locaux → rien n'est écrasé).
if [ ! -d .git ]; then
  echo "→ Initialisation du dépôt Git..."
  git init -q
  git branch -M main
  git remote add origin "$REPO"
  git fetch -q origin main
  git reset --soft origin/main
fi

# Tout le contenu du site : pages, CNAME, .nojekyll, robots.txt, sitemap.xml,
# images... Le .gitignore exclut déjà les templates promo/marquee/tile, build/ et *.zip.
# (Avant, on n'ajoutait que les .html + CNAME, ce qui laissait sitemap.xml et
#  og-cover.png hors du repo alors que les pages les référencent.)
git add -A

if git diff --cached --quiet; then
  echo "✅ Rien à déployer (aucun changement)."
  exit 0
fi

echo "→ Fichiers déployés :"
git diff --cached --name-only | sed 's/^/   /'

git commit -q -m "$MSG"
git push -q origin main
echo "✅ Déployé. Propagation sur tabsuspender.app dans ~1-2 min."
