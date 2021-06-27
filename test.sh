#!/bin/bash

cirrus_branch=$(env | grep CIRRUS_BRANCH | cut -d = -f2)

# Branch name-format check

if [[ $cirrus_branch == "$user_name-$lunch_device-$rom_name" ]]
then
	echo "Branch-Check Status= Passed!"

elif [[ $cirrus_branch == "$user_name-$brunch_device-$rom_name" ]]
then
	echo "Branch-Check Status= Passed!"

else
	echo "Branch-Check Status= Failed!"
	echo "Cause= Incorrect branch name-format!"
	echo "Tip= Use name-format as 'git username-device codename-rom name'"
	echo "Rom name should be from repo init line. For Example, for Pixel Experience (https://github.com/PixelExperience/manifest), rom name should be PixelExperience"
	echo "                                                                                              ^             ^"
	exit 1;
fi
