#!/bin/bash


## FAC: Final Auto-Checker
#   version 0.0.0

## Changelog
#
#   version 0.0.0:
#     initial release


## Parameters
#   $@	zip files to check


## Return code
#   0	if everything went all right
#   1	if an error was raised


## Const
					# the list of single file to check for
					#  (do not use any pattern matching)
readonly files=('SCIPER' 'README' 'JOURNAL' '*.xml' 'src/' 'res/' \
		'SConstruct' 'RESPONSES')
					# check for one of the files
readonly one_of=('doc/html' 'CONCEPTION')
readonly tmp_dir="/tmp/FAC"
				

# if error or not set variable, exit
set -eu

# print the syntax with the given error message
#  $@	the error message
syntax ()
{
	echo 'FAZ: Final Auto-Checker'
	echo 'Usage:'
	echo -e "\t$0 zip-files-to-check"
	echo
	error $@
}

# error function (which print in red)
#  $@	the prompt before crashing
error ()
{
	echo -e "\x1b[31m$@\x1b[0m"
	exit 1
}

# default template for missing file
#  $1	the name of the archive
#  $2	the name of the file
error_file ()
{
	error "$1: Le fichier (ou dossier) \"$2\" n'existe pas (ou est vide)"
}

# check if wanted files does exist
#  $1	the name of the current archive
check_files ()
{
	for f in ${files[*]}
	do
		[[ -s "$f" ]] || error_file "$1" "$f"
	done

	exist=0
	error_msg="Un des fichiers suivant est soit vide, soit n'existe pas:"
	for a in ${one_of[*]}
	do
		[[ -s "$a" ]] && exist=1 && break
		error_msg="$error_msg $a,"
	done
	error_msg=${error_msg:0:-1}

	[[ $exist -eq 1 ]] || error "$1: $error_msg"
}

# check if the required argument is set
#  $@	the arguments
check_args ()
{
	[[ 1 -le $# ]] || syntax 'Vous n'\''avez par rentré de zip'
}

# entry point
main()
{
	check_args $@
	mkdir -p "$tmp_dir"
	old_dir=$(pwd)

	for arg in $@
	do
		cd "$tmp_dir"
		rm -fr *
		unzip -q "$old_dir/$arg"
		check_files "$arg"
	done

	# go back
	rm -r "$tmp_dir"
	cd $old_dir

	# success
	echo -e '\x1b[32mTests fini, tout correct (mais version alpha)\x1b[0m'
}

main $@
exit 0
