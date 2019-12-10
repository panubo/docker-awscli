#!/usr/bin/env bash
# Update the Dockerfile to use the latest release and associated checksum

set -e

if [[ "$(uname -s)" == "Darwin" ]]; then
  osx_compat="g"
fi

# Get all tags, sort by version, limit to v1.* and return the latest
latest="$(curl -sSf https://api.github.com/repos/aws/aws-cli/tags | jq -r '.[] | .name' | sort -r --version-sort | grep '^1\.' | head -n1)"
version="${latest#v}"

echo "Latest: ${version}"

if [[ ! -e awscli-bundle-${version}.zip ]]; then
  curl -sSf -o awscli-bundle-${version}.zip https://s3.amazonaws.com/aws-cli/awscli-bundle-${version}.zip
fi

checksum="$(sha256sum awscli-bundle-${version}.zip | ${osx_compat}sed -E -e 's/([0-9a-f]+) .*/\1/')"

echo "Checksum: ${checksum}"

${osx_compat}sed -i -E -e "s/AWS_CLI_VERSION=[0-9\\.]*/AWS_CLI_VERSION=${version}/" -e "s/AWS_CLI_CHECKSUM=[0-9a-f]*/AWS_CLI_CHECKSUM=${checksum}/" Dockerfile
