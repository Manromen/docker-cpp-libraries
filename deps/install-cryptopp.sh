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

declare CRYPTOPP_VERSION=6.0.0
declare CRYPTOPP_VERSION2=6_0_0

#=======================================================================================================================
# globals

declare CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
declare CRYPTOPP_TARBALL="cryptopp_${CRYPTOPP_VERSION}.tar.gz"
declare CRYPTOPP_DOWNLOAD_URI="https://github.com/weidai11/cryptopp/archive/CRYPTOPP_${CRYPTOPP_VERSION2}.tar.gz"

#=======================================================================================================================

function download()
{
    # only download if not already present
    if [ ! -s ${CRYPTOPP_TARBALL} ]; then
        echo "Downloading ${CRYPTOPP_TARBALL}"
        curl -L -o ${CRYPTOPP_TARBALL} ${CRYPTOPP_DOWNLOAD_URI}
    else
        echo "${CRYPTOPP_TARBALL} already existing"
    fi
}

#=======================================================================================================================


function unpack()
{
    [ -f "${CRYPTOPP_TARBALL}" ] || abort "Source tarball missing."

    echo "Unpacking \"${CRYPTOPP_TARBALL}\"..."

    tar -xvzf "${CRYPTOPP_TARBALL}"
}

#=======================================================================================================================

function build()
{
    echo "building ..."
    
    # cmake / build
    rm -r "${CURRENT_DIR}/build" || true
    mkdir "${CURRENT_DIR}/build"
    cd "${CURRENT_DIR}/build"

    cmake ../cryptopp-CRYPTOPP_${CRYPTOPP_VERSION2}
    make
    make install

    cd "${CURRENT_DIR}"
}

#=======================================================================================================================

function cleanup()
{
    rm -r "${CURRENT_DIR}/build"
    rm -r "${CURRENT_DIR}/cryptopp-CRYPTOPP_${CRYPTOPP_VERSION2}"
}

#=======================================================================================================================

echo "################################################################################\n"
echo "###                            INSTALLING Crypto++                           ###\n"
echo "################################################################################\n"

download
unpack
build
cleanup
