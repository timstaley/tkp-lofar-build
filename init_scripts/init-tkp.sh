#!/bin/bash

# Adds a TKP build to the environment bin/lib/python paths.
#
# This file should be copied to $TKP_BUILDS_DIR as defined in CONFIG.
# The admin should then manually create a symlink 'tkp-build-default' in 
# $TKP_BUILDS_DIR which points to the desired default buildset under 
# $$TKP_BUILDS_DIR/archive/  (usually the one referenced by 
# the symlink at $TKP_BUILDS_DIR/tkp-latest ).
#
# Note that users can define PREF_TKP_BUILD before sourcing this,
# if a particular buildset is preferred.

SAL_LOGDIR="$HOME/.salbuilds"

INIT_SCRIPT_STARTDIR=$(pwd)

if [[ -z "$PREF_TKP_BUILD" ]];
then
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
    PREF_TKP_BUILD=$( cd $SCRIPT_DIR/default-build && pwd -P )
fi

export PATH=${PATH:+${PATH}:}${PREF_TKP_BUILD}/bin 
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}${PREF_TKP_BUILD}/lib 
export PYTHONPATH=${PYTHONPATH:+${PYTHONPATH}:}${PREF_TKP_BUILD}/python-packages 

#---------------------------------------------------------------------------
#Log which builds used when:
mkdir -p $SAL_LOGDIR
echo "$(date) --- $PREF_TKP_BUILD" >> $SAL_LOGDIR/tkp_builds_used.log
cd $SCRIPT_DIR
echo "$(date) --- $PREF_TKP_BUILD --- $(whoami) --- $(hostname)" >> tkp_builds_used.log
unset SAL_LOGDIR
#---------------------------------------------------------------------------
cd "$INIT_SCRIPT_STARTDIR"
unset INIT_SCRIPT_STARTDIR