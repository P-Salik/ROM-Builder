#!/bin/bash

check_final=$(env | grep CIRRUS_COMMIT_MESSAGE | grep FINAL -n | cut -d : -f1)

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
