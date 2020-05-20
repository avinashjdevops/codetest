#!/bin/bash

# Configuration
REPO=https://github.com/avinashjdevops/codetest1.git
DEST=/home/testuser/mycode
OWNER=testuser
TARFILE="${DEST}.tgz"
REMOTE_USER=testuser
REMOTE_HOST=remote.test.com
REMOTE_DEST=/home/testuser/remotecode
REMOTE_EXTRACT_DIR=/user/node/data
ENDPOINT="http://remote.test.com/status"

set -e

which git >/dev/null 2>&1
which python >/dev/null 2>&1
which curl >/dev/null 2>&1

[[ -d $DEST ]] && /bin/rm -rf $DEST

git clone $REPO $DEST

cd $DEST
python update-config.py

chown -R "${OWNER}:" $DEST

tar zcf $TARFILE .

CKSUM=$(cksum $TARFILE)
echo "Checksum of $TARFILE: $CKSUM"


ssh $REMOTE_USER@$REMOTE_HOST "mkdir -p $REMOTE_DEST"

scp $TARFILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST

ssh $REMOTE_USER@$REMOTE_HOST "sudo /usr/sbin/service node stop"

ssh $REMOTE_USER@$REMOTE_HOST "/bin/mv -f ${REMOTE_DEST}/mycode.tgz $REMOTE_EXTRACT_DIR"

ssh $REMOTE_USER@$REMOTE_HOST "cd $REMOTE_EXTRACT_DIR && tar zmxf mycode.tgz"

ssh $REMOTE_USER@$REMOTE_HOST "sudo /usr/sbin/service node start"

sleep 1
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" $ENDPOINT)
echo "Endpoint status code: $STATUS_CODE"

[[ "$STATUS_CODE" == "200" ]] && exit 0 || exit 1
