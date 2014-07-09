#!/bin/bash

function install()
{
    # Clean Up

    rm -rf "${kibanaInstallFolder}"
    mkdir -p "${kibanaInstallFolder}"

    # Install

    unzipRemoteFile "${kibanaDownloadURL}" "${kibanaInstallFolder}"
}

function main()
{
    appPath="$(cd "$(dirname "${0}")" && pwd)"

    source "${appPath}/../../../lib/util.bash" || exit 1
    source "${appPath}/../attributes/default.bash" || exit 1
    source "${appPath}/../../nginx/attributes/default.bash" || exit 1

    checkRequireDistributor

    header 'INSTALLING KIBANA'

    checkRequireRootUser

    install
    installCleanUp
}

main "${@}"