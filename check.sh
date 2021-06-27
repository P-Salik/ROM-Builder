#!/bin/bash

check_final=$(env | grep CIRRUS_COMMIT_MESSAGE | grep FINAL -n | cut -d : -f1)
lunch_or_brunch=$(grep lunch "$CIRRUS_WORKING_DIR"/build.sh | wc -l)

if [[ $lunch_or_brunch -eq 1 ]]
then
        sed -i "s/upload_rom/\#up \/tmp\/rom\/out\/target\/product\/$lunch_device\/\*\.zip/" "$CIRRUS_WORKING_DIR"/build.sh

elif [[ $lunch_or_brunch -eq 0 ]]
then
        sed -i "s/upload_rom/\#up \/tmp\/rom\/out\/target\/product\/$brunch_device\/\*\.zip/" "$CIRRUS_WORKING_DIR"/build.sh

fi

if [[ $check_final -gt 0 ]]
then
	sed -i "s/#make_metalava/make_metalava/" "$CIRRUS_WORKING_DIR"/build.sh
	sed -i "s/sleep/#sleep/" "$CIRRUS_WORKING_DIR"/build.sh
	sed -i "s/kill/#kill/" "$CIRRUS_WORKING_DIR"/build.sh
	sed -i "s/--all) &/--all)/" "$CIRRUS_WORKING_DIR"/build.sh
	sed -i "s/#up\ \/tmp\/rom/up\ \/tmp\/rom/" "$CIRRUS_WORKING_DIR"/build.sh
	echo "FINAL keywork detected in Commit Message, Triggering final Build"

else
	echo "You're Good To Go"
fi
