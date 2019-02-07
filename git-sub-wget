#!/usr/bin/env bash
function cmdcheck() { type >/dev/null 2>&1 "$@"; }
! cmdcheck 'svn' && echo "'svn' is required" && exit 1
! cmdcheck 'git' && echo "'git' is required" && exit 1

function main() {
	[[ $# == 0 ]] && echo "Usage: $0 <git repo url>" && exit 1

	local git_url="$1"
	local tmpdir=$(mktemp -d "/tmp/$(basename $0).$$.tmp.XXXXXX")
	local cwd=$PWD
	pushd $tmpdir >/dev/null 2>&1
	local dirname=${git_url##*/}
	local svn_url=$(printf '%s' "$git_url" | sed -E 's/(blob|tree)\/master/trunk/')
	local svn_checkout_message
	svn_checkout_message=$(svn checkout "$svn_url" 2>&1)
	local exit_code=$?
	if [[ $exit_code == 0 ]]; then
		# NOTE: url is dir
		rm -rf "$dirname/.svn"
	elif [[ $exit_code == 1 ]]; then
		# NOTE: svn checkout: refers to a file, not a directory
		local svn_checkout_message
		svn_checkout_message=$(svn export "$svn_url" 2>&1)
		local exit_code=$?
	fi
	if [[ $exit_code != 0 ]]; then
		echo "$svn_checkout_message" 1>&2
	else
		cp -R . "$cwd"
	fi
	popd >/dev/null 2>&1
	[[ -d "$tmpdir" ]] && rm -rf "$tmpdir"
	return $exit_code
}
for arg in "$@"; do
	main "$arg" || exit $?
done
