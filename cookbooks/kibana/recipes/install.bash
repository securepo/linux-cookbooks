#!/bin/bash -e

function install()
{
    umask '0022'

    # Clean Up

    initializeFolder "${KIBANA_INSTALL_FOLDER_PATH}"

    # Install

    unzipRemoteFile "${KIBANA_DOWNLOAD_URL}" "${KIBANA_INSTALL_FOLDER_PATH}"

    # Config Server

    createFileFromTemplate \
        "${KIBANA_INSTALL_FOLDER_PATH}/config/kibana.yml" \
        "${KIBANA_INSTALL_FOLDER_PATH}/config/kibana.yml" \
        'http://localhost:9200' "${KIBANA_ELASTIC_SEARCH_URL}"

    # Config Profile

    createFileFromTemplate \
        "$(dirname "${BASH_SOURCE[0]}")/../templates/kibana.sh.profile" \
        '/etc/profile.d/kibana.sh' \
        '__INSTALL_FOLDER_PATH__' "${KIBANA_INSTALL_FOLDER_PATH}"

    # Config Init

    createInitFileFromTemplate \
        "${KIBANA_SERVICE_NAME}" \
        "$(dirname "${BASH_SOURCE[0]}")/../templates" \
        '__INSTALL_FOLDER_PATH__' "${KIBANA_INSTALL_FOLDER_PATH}" \
        '__USER_NAME__' "${KIBANA_USER_NAME}" \
        '__GROUP_NAME__' "${KIBANA_GROUP_NAME}"

    # Start

    addUser "${KIBANA_USER_NAME}" "${KIBANA_GROUP_NAME}" 'false' 'true' 'false'
    chown -R "${KIBANA_USER_NAME}:${KIBANA_GROUP_NAME}" "${KIBANA_INSTALL_FOLDER_PATH}"
    startService "${KIBANA_SERVICE_NAME}"

    # Display Open Ports

    displayOpenPorts '5'

    umask '0077'
}

function main()
{
    source "$(dirname "${BASH_SOURCE[0]}")/../../../libraries/util.bash"
    source "$(dirname "${BASH_SOURCE[0]}")/../attributes/default.bash"

    header 'INSTALLING KIBANA'

    checkRequireLinuxSystem
    checkRequireRootUser

    install
    installCleanUp
}

main "${@}"