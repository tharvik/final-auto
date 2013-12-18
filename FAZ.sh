#!/bin/bash


## FAZ: Final Auto-Zipper
#   version 0.0.3

## Changelog
#
#   version 0.0.3:
#     remove groupe number (as there wasn't groupe number)
#
#   version 0.0.2:
#     add *.xml to files
#
#   version 0.0.1:
#     add one_of const
#     add CONCEPTION check, move RESPONSES to files
#     add readonly attributes to const
#     add some documentation
#     be more consistant in the error messages
#
#   version 0.0.0:
#     initial release


## Parameters
#   $1	group number


## Return code
#   0	if everything went all right
#   1	if an error was raised


## Const
readonly output_prefix="bee"		# the output prefix for the archive
					# the list of single file to check for
					#  (do not use any pattern matching)
readonly files=('SCIPER' 'README' 'JOURNAL' '*.xml' 'src/' 'res/' \
		'SConstruct' 'RESPONSES')
					# check for one of the files
readonly one_of=('doc/html' 'CONCEPTION')
				

# if error or not set variable, exit
set -eu

# print the syntax with the given error message
#  $@	the error message
syntax ()
{
	echo 'FAZ: Final Auto-Zipper'
	echo 'Usage:'
	echo -e "\t$0 number-du-groupe"
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
#  $1	the name of the file
error_file ()
{
	error "Le fichier (ou dossier) \"$1\" n'existe pas (ou est vide)"
}

# check if wanted files does exist
check_files ()
{
	for f in ${files[*]}
	do
		[[ -s "$f" ]] || error_file "$f"
	done

	exist=0
	error_msg="Un des fichiers suivant est soit vide, soit n'existe pas:"
	for a in ${one_of[*]}
	do
		[[ -s "$a" ]] && exist=1 && break
		error_msg="$error_msg $a,"
	done
	error_msg=${error_msg:0:-1}

	[[ $exist -eq 1 ]] || error "$error_msg"
}

# check if the required argument is set
#  $@	the arguments
check_args ()
{
	local readonly wrong_number='Vous avez rentré un numéro de groupe trop'

	[[ 1 -eq $# ]] || syntax 'Vous n'\''avez par rentré le numéro du groupe'
	[[ 0 -lt $1 ]] || syntax $wrong_number 'petit'
}

# entry point
main()
{
	check_args $@
	check_files

	# zip it
	rm -f "$output_prefix-$1.zip"
	zip -qr -9 "$output_prefix-$1.zip" ${one_of[*]} ${files[*]} -x */.*

	# success
	echo -e '\x1b[32mArchive finie (verifiez quand même le contenu)\x1b[0m'
}

main $@
exit 0
