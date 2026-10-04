#!/bin/bash
# package_submission.sh
#
# Gradescope's GitHub integration only syncs the tip of your `main` branch. It does not
# see your other branches or tags. This script bundles your ENTIRE local repository
# (all branches, all tags, full history) into a single file, submission.bundle, so that
# after you commit and push it to main, the Gradescope autograder can reconstruct your
# full repository and grade Tasks 1-4.
#
# Run this from the root of your repository, AFTER completing Tasks 1-4, while checked
# out on main.

set -e

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null)"
if [ -z "$REPO_ROOT" ]; then
    echo "❌ This does not look like a git repository. Run this script from inside your cloned repo."
    exit 1
fi
cd "$REPO_ROOT"

CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  You are on branch '$CURRENT_BRANCH', not 'main'."
    echo "   Switch to main first: git checkout main"
    exit 1
fi

echo "--- Creating submission.bundle (all branches and tags) ---"
git bundle create submission.bundle --all

echo "--- Verifying bundle integrity ---"
git bundle verify submission.bundle

echo ""
echo "✅ submission.bundle created and verified."
echo ""
echo "Next steps:"
echo "  git add submission.bundle"
echo "  git commit -m \"chore: add submission bundle for grading\""
echo "  git push origin main"
