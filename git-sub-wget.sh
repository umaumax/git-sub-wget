#!/usr/bin/env bash
cmdcheck() { type >/dev/null 2>&1 "$@"; }
cmdcheck 'svn' || (echo "'svn' is required" && exit 1)
cmdcheck 'git' || (echo "'git' is required" && exit 1)

[[ $# == 0 ]] && echo "Usage: $0 <git repo url>" && exit 1

git_url="$1"
dirname=${git_url##*/}
svn_url=$(echo "$git_url" | sed -E 's/(blob|tree)\/master/trunk/')
svn checkout "$svn_url"
exit_code=$?
[[ $exit_code == 0 ]] && rm -rf "$dirname/.svn"
# svn checkout: refers to a file, not a directory
if [[ $exit_code == 1 ]]; then
	svn export "$svn_url"
	exit_code=$?
fi
exit $exit_code
