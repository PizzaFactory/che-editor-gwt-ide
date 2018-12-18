#!/bin/sh
set -e
set -u



./build.sh

version=che-editor-gwt-ide-$(date +'%F_%k%M-%S')
git tag $version
git push --tags
text="Release of Che Editor Gwt IDE"
branch=master
repo_full_name=eclipse/che-editor-gwt-ide
token=$GITHUB_RELEASE_TOKEN
generate_post_data()
{
  cat <<EOF
{
  "tag_name": "$version",
  "target_commitish": "master",
  "name": "$version",
  "body": "Description of the release",
  "draft": false,
  "prerelease": false
}
EOF
}

echo "Create release $version for repo: $repo_full_name branch: $branch"
rel_id=$(curl  -s --data "$(generate_post_data)" "https://api.github.com/repos/$repo_full_name/releases?access_token=$token"| jq -r .id)
echo "Uploading file build/che-editor-plugin.tar.gz"
download_ulr=$(curl  -s -X POST "https://uploads.github.com/repos/$repo_full_name/releases/${rel_id}/assets?name=che-editor-plugin.tar.gz&access_token=$token" \
 --header 'Content-Type: text/javascript ' --upload-file build/che-editor-plugin.tar.gz | jq -r .browser_download_url)
echo "Download url $download_ulr"

rm build/che-editor-plugin.tar.gz