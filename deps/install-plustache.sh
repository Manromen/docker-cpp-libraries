#!/bin/bash
# ----------------------------------------------------------------------------------------------------------------------
# The MIT License (MIT)
#
# Copyright (c) 2017 Ralph-Gordon Paul. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated 
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the 
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit 
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
# ----------------------------------------------------------------------------------------------------------------------

set -e

#=======================================================================================================================
# settings

declare PLUSTACHE_VERSION=0.4.0

#=======================================================================================================================
# globals

declare CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare PLUSTACHE_TARBALL="plustache-${PLUSTACHE_VERSION}.tar.gz"
declare PLUSTACHE_DOWNLOAD_URI="https://github.com/mrtazz/plustache/archive/${PLUSTACHE_VERSION}.tar.gz"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${PLUSTACHE_TARBALL} ]; then
        echo "Downloading ${PLUSTACHE_TARBALL}"
        curl -L -o ${PLUSTACHE_TARBALL} ${PLUSTACHE_DOWNLOAD_URI}
    else
        echo "${PLUSTACHE_TARBALL} already existing"
    fi
}

#=======================================================================================================================


function unpack()
{
    [ -f "${PLUSTACHE_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${PLUSTACHE_TARBALL}\"..."

    tar -xvzf "${PLUSTACHE_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    # configure / make
    cd "${CURRENT_DIR}/plustache-${PLUSTACHE_VERSION}"

    autoreconf -i
    ./configure --enable-static --disable-shared
    make
    make install

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${CURRENT_DIR}/plustache-${PLUSTACHE_VERSION}"
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                            INSTALLING plustache                          ###\n"
echo "################################################################################\n"


download
unpack
build
cleanup
