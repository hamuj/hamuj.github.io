#!/data/data/com.termux/files/usr/bin/bash
# Quick deploy script for GitHub Pages from Termux

echo "=== Deploying to GitHub Pages ==="

if [ ! -d .git ]; then
  echo "❌ Not a git repository. Run this inside your username.github.io folder."
  exit 1
fi

read -p "Enter commit message (leave blank for auto): " COMMIT_MSG

if [ -z "$COMMIT_MSG" ]; then
  COMMIT_MSG="Auto-update: $(date '+%Y-%m-%d %H:%M:%S')"
fi

SITE_URL="https://hamuj.github.io"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
LOG_ENTRY="$(date '+%Y-%m-%d %H:%M:%S') | $COMMIT_MSG | $SITE_URL"

# Ensure logs folder exists
mkdir -p logs

# Write to master log
echo "$LOG_ENTRY" >> deploy.log

# Write to individual log file
echo "Deployment Log" > "logs/$TIMESTAMP.log"
echo "---------------------------" >> "logs/$TIMESTAMP.log"
echo "Date: $(date '+%Y-%m-%d %H:%M:%S')" >> "logs/$TIMESTAMP.log"
echo "Commit: $COMMIT_MSG" >> "logs/$TIMESTAMP.log"
echo "URL: $SITE_URL" >> "logs/$TIMESTAMP.log"

# Git add, commit, push (including logs)
git add .
git commit -m "$COMMIT_MSG" || echo "No changes to commit"
git push origin main || git push origin master

echo "📝 Logged: $LOG_ENTRY"
echo "📂 Detailed log saved at: logs/$TIMESTAMP.log"

echo "✅ Deployment complete!"
echo "🌍 Opening your site: $SITE_URL"

# Open in default browser if possible
if command -v xdg-open > /dev/null; then
  xdg-open "$SITE_URL" >/dev/null 2>&1 &
else
  echo "⚠️ Install xdg-utils to auto-open browser: pkg install xdg-utils"
fi
