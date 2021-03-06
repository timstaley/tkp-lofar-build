#!/bin/bash
####################################################################
BRANCH_TO_BUILD=$1
if [[ -z "$BRANCH_TO_BUILD" ]]; then
    BRANCH_TO_BUILD=master
fi

startdir=`pwd`
BUILD_SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
source $BUILD_SCRIPTS_DIR/CONFIG
source $BUILD_SCRIPTS_DIR/utils.sh

#------------------------------------------------------------------------------
#Setup
echo 
echo "*** Creating install directories ***"
ARCHIVE_TARGET=$TKP_BUILDS_DIR/${BRANCH_TO_BUILD}-builds/`date +%F-%H-%M`
echo "Target: ${ARCHIVE_TARGET}"
mkdir -p $ARCHIVE_TARGET

echo "Installing into $ARCHIVE_TARGET"

#------------------------------------------------------------------------------
if [[ -n $UPDATE_REPOS ]]; then
	update_git_repo $TKP_SVNROOT/tkp $BRANCH_TO_BUILD
	echo
	echo "*** Sources updated ***"
fi
#------------------------------------------------------------------------------

echo 
echo "**** Building TKP... **** "

#Within the archive folder, we create a subfolder which tags the build with its SHA hash:
cd $TKP_SVNROOT/tkp
TKP_SHA=$(get_git_short_hash)
BUILD_TARGET=${ARCHIVE_TARGET}/tkp_${TKP_SHA}
echo "TKP SHA tagged build target is $BUILD_TARGET"

ln -sfn $BUILD_TARGET $TKP_BUILDS_DIR/${BRANCH_TO_BUILD}-latest
cp $BUILD_SCRIPTS_DIR/init_scripts/tkp/init-script.sh $TKP_BUILDS_DIR

#----------------------------------------------------------------------------
#Build and install TKP libs

rm -rf $TKP_SVNROOT/tkp/build 
cd $TKP_SVNROOT/tkp

build_command="python setup.py install
                 --install-lib=${BUILD_TARGET}/python-packages
                 --install-scripts=${BUILD_TARGET}/bin
                 --install-data=${BUILD_TARGET}/python-packages
"
echo $build_command > build_command.sh
bash build_command.sh
check_result "tkp" "python install" $?
 

#----------------------------------------------------------------------------
#------------------------------------------------------------------------------

