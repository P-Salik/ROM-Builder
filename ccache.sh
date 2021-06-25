# download

df -h
free -h
nproc
cat /etc/os*
env

# Add your ccache link here
url=

cd /tmp
time aria2c $url -x16 -s50
time tar xf ccache.tar.gz
rm -rf ccache.tar.gz

# monitor

export CCACHE_DIR=/tmp/ccache
sleep 2m

while :
do
ccache -s
echo ''
top -b -i -n 1
sleep 1m
done

# upload

cd /tmp

com ()
{
    tar --use-compress-program="pigz -k -$2 " -cf $1.tar.gz $1
}

time com ccache 1

# Use Your own RClone Config!
mkdir -p ~/.config/rclone
echo "$rclone_config" > ~/.config/rclone/rclone.conf
time rclone copy ccache.tar.gz aosp:ccache/ccache-ci2 -P
