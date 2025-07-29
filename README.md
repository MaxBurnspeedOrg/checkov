# Checkov

# Pre-Commit Checks
If you need to run the checks manually (from the root of the repo), run: \
pre-commit run --all-files

pre-commit run --all-files trailing-whitespace \
pre-commit run --all-files end-of-file-fixer \
pre-commit run --all-files check-added-large-files \
pre-commit run --all-files check-merge-conflict \
pre-commit run --all-files debug-statements

To update pre-commit versions: \
pre-commit autoupdate

To skip checks: \
git push --no-verify
