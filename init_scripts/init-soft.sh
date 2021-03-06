#!/bin/bash

# Adds a stable software buildset to the environment bin/lib/python paths.
#
# This file should be copied to $STABLE_SOFT_DIR as defined in CONFIG.
# The admin should then manually create a symlink 'default-buildset' in 
# $STABLE_SOFT_DIR which points to the desired default buildset under 
# $STABLE_SOFT_DIR/symlinks/archive/  (usually the one referenced by 
# the symlink at $STABLE_SOFT_DIR/symlinks/buildset-latest ).
#
# Note that users can define PREF_SOFT_BUILD before sourcing this,
# if a particular buildset is preferred.

SAL_LOGDIR="$HOME/.salbuilds"
SAL_INIT_SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"

if [[ -z "$PREF_SOFT_BUILD" ]];
then
    if ! [ -L $SAL_INIT_SCRIPT_DIR/default-buildset ]; then 
        echo "Please create a default-buildset pointing symlink, e.g. using"
        echo "ln -sfnv \$(readlink $SAL_INIT_SCRIPT_DIR/symlinks/buildset-latest) $SAL_INIT_SCRIPT_DIR/default-buildset"
        return 1
    fi    
    PREF_SOFT_BUILD=$( cd $SAL_INIT_SCRIPT_DIR/default-buildset && pwd -P )
fi

export PATH=${PREF_SOFT_BUILD}/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=${PREF_SOFT_BUILD}/lib${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
export PYTHONPATH=${PREF_SOFT_BUILD}/python-packages${PYTHONPATH:+:${PYTHONPATH}} 

#---------------------------------------------------------------------------
#Log which builds used when:
mkdir -p $SAL_LOGDIR
echo "$(date) --- $PREF_SOFT_BUILD" >> $SAL_LOGDIR/soft_buildsets_used.log
echo "$(date) --- $PREF_SOFT_BUILD --- $(whoami) --- $(hostname)" >> "${SAL_INIT_SCRIPT_DIR}/soft_buildsets_used.log"
unset SAL_LOGDIR
unset SAL_INIT_SCRIPT_DIR
#---------------------------------------------------------------------------

