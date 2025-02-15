#!/bin/bash

# Args
SQUASH=""
if [ "${INPUT_SQUASH}" == "true" ]; then
	SQUASH="--squash"
fi

# Fix dubious ownership
git config --global --add safe.directory /github/workspace

# Set git email and name
git config --global user.email "${INPUT_GIT_EMAIL}"
git config --global user.name "${INPUT_GIT_NAME}"

# Make sure there are no prompts for git commands
cp .git/config .git/config-original
git config --global url."https://api:${INPUT_PAT}@github.com/".insteadOf "https://github.com/"
git config --unset http."https://github.com/".extraheader

# Update subtree
git subtree ${INPUT_ACTION} -d --prefix=${INPUT_PREFIX} "${INPUT_REPO}" "${INPUT_POSITION}" $SQUASH

# Revert git config change
cp -f .git/config-original .git/config
