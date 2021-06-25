# sync
ROM_MANIFEST=https://github.com/PixelExperience/manifest
BRANCH=eleven
LOCAL_MANIFEST=https://github.com/P-Salik/local_manifest
MANIFEST_BRANCH=main

mkdir -p /tmp/rom
cd /tmp/rom

repo init -q --no-repo-verify --depth=1 -u "$ROM_MANIFEST" -b "$BRANCH" -g default,-device,-mips,-darwin,-notdefault

git clone "$LOCAL_MANIFEST" --depth 1 -b "$MANIFEST_BRANCH" .repo/local_manifests

repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j 30 || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# Patches
# Add Patches here

# Build
cd /tmp/rom

. build/envsetup.sh
lunch aosp_RMX1941-userdebug

export SKIP_API_CHECKS=true
export SKIP_ABI_CHECKS=true

export CCACHE_DIR=/tmp/ccache
export CCACHE_EXEC=$(which ccache)
export USE_CCACHE=1

ccache -M 20G
ccache -o compression=true
ccache -z
ccache -s

# metalava
make_metalava(){
	mka api-stubs-docs
	mka system-api-stubs-docs
	mka test-api-stubs-docs
}

#make_metalava
mka bacon -j$(nproc --all) &
sleep 90m
kill %1 || echo "Build already failed or completed"
ccache -s

# upload
up(){
	mkdir -p ~/.config/rclone
	echo "$rclone_config" > ~/.config/rclone/rclone.conf
	time rclone copy $1 aosp:ccache/ccache-ci -P
}

#up /tmp/rom/out/target/product/RMX1941/*.zip

ccache -s
