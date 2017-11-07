#!/bin/bash

GIT_COMMIT=2d652e157a4841830f616fbc9be69d8fddf2ae2e
GIT_BRANCH=lospringliu
if git show $GIT_COMMIT > /dev/null 2>&1
then
	if git branch | grep -q "\* $GIT_BRANCH$"
	then
		echo "branch $GIT_BRANCH exists and current, deleting it first..."
		git add -A
		git commit -m "commit before delete"
		git checkout master
		git branch -D $GIT_BRANCH
	elif git branch | grep -q " $GIT_BRANCH$"
	then
		echo "branch $GIT_BRANCH exists, deleting it first..."
		git branch -D $GIT_BRANCH
	else
		echo
	fi
	git checkout -b $GIT_BRANCH
else
	echo "you have to run at root of the git repo angular-seed-advanced"
	exit 9
fi


APP_NAME=lospringliu
APP_VERSION=0.0.1
APP_DESCRIPTION="lospringliu using Advanced seed for Angular"
APP_URL="https://github.com/lospringliu/angularseedadvanced"

APP_ID="com.firebaseapp.lospringliu"

WORKINGDIR=`pwd`
echo ... deploying at $WORKINGDIR
SCRIPTDIR=`dirname $0`
echo ... source dir is $SCRIPTDIR


echo "Updating package.json"
sed -e "s|\"name\": \"angular-seed-advanced\"|\"name\": \"$APP_NAME\"|" package.json > /tmp/package.json && cat /tmp/package.json > package.json
sed -e "s|\"version\": \"0.0.0\"|\"version\": \"$APP_VERSION\"|" package.json > /tmp/package.json && cat /tmp/package.json > package.json
sed -e "s|\(.*\"description\":\).*\"|\1 \"$APP_DESCRIPTION\"|" package.json > /tmp/package.json && cat /tmp/package.json > package.json
sed -e "s|\"url\": \"https://github.com/NathanWalker/angular-seed-advanced\"|\"url\": \"$APP_URL\"|" package.json > /tmp/package.json && cat /tmp/package.json > package.json
echo "Check difference"
git diff package.json

echo "Updating nativescript/package.json"
sed -e "s|\"name\": \"angular-seed-advanced\"|\"name\": \"$APP_NAME\"|" nativescript/package.json > /tmp/package.json && cat /tmp/package.json > nativescript/package.json
sed -e "s|\"id\": \"com.yourdomain.nativescript\"|\"id\": \"$APP_ID\"|" nativescript/package.json > /tmp/package.json && cat /tmp/package.json > nativescript/package.json
sed -e "s|\"version\": \"0.0.0\"|\"version\": \"$APP_VERSION\"|" nativescript/package.json > /tmp/package.json && cat /tmp/package.json > nativescript/package.json
echo "Check difference"
git diff nativescript/package.json

echo "Trying to deploy more files, check carefully"
find $SCRIPTDIR/src -type f | while read SRCFILE
do
	SRCFILE=${SRCFILE#*angularseedadvanced/}
	echo "... found source file ${SRCFILE}"
	if [ -f ${SRCFILE} ]
	then
		echo "... ${SRCFILE} exists"
	else
		echo "!!! ${SRCFILE} disappear, inspect please"
	fi
	cp -av ${SCRIPTDIR}/${SRCFILE} ${SRCFILE}
done
