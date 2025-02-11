#!/bin/bash

source ${GITHUB_WORKSPACE}/config.sh
timeStart

cd ${GITHUB_WORKSPACE}/OrangeFox/fox_${FOX_SYNC_BRANCH}
echo -e ${cya} "Starting Building OrangeFox Recovery..."
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"
BUILDLOG="${GITHUB_WORKSPACE}/OrangeFox/fox_${FOX_SYNC_BRANCH}/build.log"
build_message "Prepare for build..."
. build/envsetup.sh
build_message "lunch twrp_${DEVICE_NAME}-eng"
lunch twrp_${DEVICE_NAME}-eng || { echo -e ${red} "ERROR: Failed to lunch the target device!" && exit 1; }
mkfifo reading
tee "${BUILDLOG}" < reading &
build_message "Staring bro...🔥"
sleep 2
build_message "🛠️ Building..."
progress |& mka -j$(nproc --all) ${BUILD_TARGET} > reading || { echo -e ${red} "ERROR: Failed to Build OrangeFox!" && exit 1; }

retVal=$?
timeEnd
statusBuild

# Exit
exit 0
