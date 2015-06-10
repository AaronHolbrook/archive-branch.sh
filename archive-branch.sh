#!/bin/sh -x
# Exit if any error is encountered:
set -o errexit
# git name-rev is fail
# Get the branch name and replace the string from an array of values for instance "feature/" with "archive/"
CURRENT=`git branch | grep '\*' | awk ' {print $2}'`
ARCHIVE=`git branch | grep '\*' | awk ' {print $2}' | sed 's,.*[a-z]/,,g' | sed 's,^,archive/,g'`

#Check if we are on master or develop since we don't want to tag those
if [ $CURRENT = 'master' ]
then
	echo 'you are on the master branch so we are done here'
	exit
elif [ $CURRENT = 'develop' ]
then
	echo 'you are on the develop branch so we are done here'
	exit
fi

# Create the tag
git tag ${ARCHIVE}
# Push the tags
git push --tags

# Ensure the origin has the branch in question
git push origin ${CURRENT}

#Switch to master branch
git checkout -f master

# Delete the local and remote branches
git push origin --delete ${CURRENT}
git branch -D ${CURRENT}
