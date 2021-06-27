#!/bin/bash

rom_name=$(grep ROM_MANIFEST= /tmp/ci/build.sh | cut -d / -f4)
user_name=$(grep LOCAL_MANIFEST= /tmp/ci/build.sh | cut -d / -f4)
lunch_device=$(grep lunch /tmp/ci/build.sh | cut -d _ -f2 | cut -d - -f1)
brunch_device=$(grep brunch /tmp/ci/build.sh | cut -d ' ' -f2 | cut -d ' ' -f1)

check_final=$(env | grep CIRRUS_COMMIT_MESSAGE | grep FINAL -n | cut -d : -f1)
lunch_or_brunch=$(grep lunch /tmp/ci/build.sh | wc -l)

if [[ $lunch_or_brunch -eq 1 ]]
then
        sed -i "s/upload_rom/\#up \/tmp\/rom\/out\/target\/product\/$lunch_device\/\*\.zip/" /tmp/ci/build.sh

elif [[ $lunch_or_brunch -eq 0 ]]
then
        sed -i "s/upload_rom/\#up \/tmp\/rom\/out\/target\/product\/$brunch_device\/\*\.zip/" /tmp/ci/build.sh

fi

if [[ $check_final -gt 0 ]]
then
        sed -i "s/#make_metalava/make_metalava/" /tmp/ci/build.sh
        sed -i "s/sleep/#sleep/" /tmp/ci/build.sh
        sed -i "s/kill/#kill/" /tmp/ci/build.sh
        sed -i "s/--all) &/--all)/" /tmp/ci/build.sh
        sed -i "s/#up\ \/tmp\/rom/up\ \/tmp\/rom/" /tmp/ci/build.sh
        echo "FINAL keywork detected in Commit Message, Triggering final Build"

else
        echo "You're Good To Go"
fi
