#!/usr/bin/env bash
#
# DO NOT EDIT THIS FILE!
#
# If you have any questions about this script, or think it is not general
# enough to cover your use case (i.e., you feel that you need to modify it
# anyway), please contact Max Horn <max.horn@math.uni-giessen.de>.
#
set -ex

# clone GAP into a subdirectory
git clone --depth=2 -b ${GAPBRANCH:-master} https://github.com/gap-system/gap.git $GAPROOT
cd $GAPROOT

# for HPC-GAP, add suitable flags
if [[ $HPCGAP = yes ]]; then
  GAP_CONFIGFLAGS="$GAP_CONFIGFLAGS --enable-hpcgap"
fi

# build GAP in a subdirectory
./autogen.sh
./configure $GAP_CONFIGFLAGS
make -j4 V=1

# download packages; instruct wget to retry several times if the
# connection is refused, to work around intermittent failures
make bootstrap-pkg-full WGET="wget -N --no-check-certificate --tries=5 --waitretry=5 --retry-connrefused"

cd pkg

# optionally: clone specific package versions, in case we need to test
# with development versions
for pkg in ${GAP_PKGS_TO_CLONE}; do
    # delete any existing variants of the package to multiple version
    # from being compiled later on
    rm -rf "$pkg"*
    if [[ "$pkg" =~ ^http ]] ; then
        # looks like a full URL
        git clone "$pkg"
    elif [[ "$pkg" =~ ^[^/]+/[^/]+$ ]] ; then
        # looks like ORG/REPO
        git clone https://github.com/"$pkg"
    elif [[ "$pkg" =~ ^[^/]+$ ]] ; then
        # looks like just a REPO name
        git clone https://github.com/gap-packages/"$pkg"
    else
        echo "Invalid package name or URL '$pkg' in GAP_PKGS_TO_CLONE"
        exit 1
    fi
done

# build some packages; default is to build 'io' and 'profiling', in order to
# generate coverage results. If you need to build additional packages (or for
# some reason need to build a custom version of io or profiling), please set
# the GAP_PKGS_TO_BUILD environment variable (e.g. in your .travis.yml), or
# directly call BuildPackages.sh from .travis.yml. For an example of the
# former, take a look at the cvec package.
for pkg in ${GAP_PKGS_TO_BUILD-io profiling}; do
    ../bin/BuildPackages.sh --strict $pkg*
done
