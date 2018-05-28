#!/bin/bash
### Block all traffic from AFGHANISTAN (af) and CHINA (CN). Use ISO code ###
ISO="af cn vn"

### Set PATH ###
WGET=/usr/bin/wget

### No editing below ###
#ZONEROOT="/root/ufwzones/"
ZONEROOT="."
DLROOT="http://www.ipdeny.com/ipblocks/data/countries"

# create a dir
[ ! -d $ZONEROOT ] && /bin/mkdir -p $ZONEROOT

for c  in $ISO
do
        # local zone file
        tDB=$ZONEROOT/$c.zone

        echo "Downloading $c.zone .."

        # get fresh zone file
        $WGET -O $tDB $DLROOT/$c.zone >> /dev/null 2>&1

        BADIPS=$(egrep -v "^#|^$" $tDB)
        for ipblock in $BADIPS
        do
           #echo "Blocking IP $ipblock.."
           echo "ufw deny from $ipblock"
        done
done

