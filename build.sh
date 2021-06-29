# sync
ROM_MANIFEST=https://github.com/Havoc-OS/android_manifest.git
BRANCH=eleven
LOCAL_MANIFEST=https://github.com/P-Salik/local_manifest
MANIFEST_BRANCH=HavocOS

mkdir -p /tmp/rom
cd /tmp/rom

repo init -q --no-repo-verify --depth=1 -u "$ROM_MANIFEST" -b "$BRANCH" -g default,-device,-mips,-darwin,-notdefault

git clone "$LOCAL_MANIFEST" --depth 1 -b "$MANIFEST_BRANCH" .repo/local_manifests

repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j 30 || repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# Patches
# [1] Boot
cd external/selinux
curl -LO https://github.com/PixelExperience/external_selinux/commit/9d6ebe89430ffe0aeeb156f572b2a810f9dc98cc.patch
patch -p1 < *.patch
cd ../..

# [2] Ims
cd frameworks/opt/net/ims
curl -LO https://github.com/PixelExperience/frameworks_opt_net_ims/commit/661ae9749b5ea7959aa913f2264dc5e170c63a0a.patch
patch -p1 < *.patch
cd ../..

# Build
cd /tmp/rom

. build/envsetup.sh
lunch havoc_RMX1941-userdebug

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

make_metalava
make sepolicy
#brunch RMX1941 -j$(nproc --all) &
#sleep 90m
#kill %1 || echo "Build already failed or completed"
ccache -s

# upload
up(){
	mkdir -p ~/.config/rclone
	echo "$rclone_config" > ~/.config/rclone/rclone.conf
	time rclone copy $1 aosp:ccache/ccache-ci -P
}

upload_rom

ccache -s
