#! /bin/bash
#
bindir=""
if echo $0 | grep -q /; then
    bindir=`dirname $0`
fi

if [ -z "$DC2PIPE_DIR" ]; then

    # make sure we load the dc2pipe environment
    version=`dirname "$bindir"`         # dc2pipe version directory
    if [ "$version" = "."  ]; then
        echo "Unable to load dc2pipe: unable to determin version from $bindir"
        exit 1
    fi

    if [ -z "$LSST_HOME" ]; then
        home=`dirname "$version"`           # dc2ipe directory
        home=`dirname "$home"`              # flavor directory
        export LSST_HOME=`dirname "$home"`  # LSST_HOME directory

    fi
    version=`basename $version`

    if [ ! -f "$LSST_HOME/loadLSST.sh" ]; then
        echo "Unable to load LSST stack; " \
             "can't find $LSST_HOME/loadLSST.sh"
        exit 1
    fi

    SHELL=/bin/bash
    source  $LSST_HOME/loadLSST.sh
    setup dc2pipe $version
fi

echo exec $bindir/ensureMpdConf.py $*
