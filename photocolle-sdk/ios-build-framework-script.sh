unset TOOLCHAINS
set -e
set +u
#avoid build on Debug configuration
if [[ "${CONFIGURATION}" = "Debug" ]]
then

exit 0
fi

# Avoid recursively calling this script.
if [[ $SF_MASTER_SCRIPT_RUNNING ]]
then
exit 0
fi
set -u
export SF_MASTER_SCRIPT_RUNNING=1


# Constants
SF_TARGET_NAME=PhotoColleSDK
UNIVERSAL_OUTPUTFOLDER=${PROJECT_DIR}/dist

# Take build target
if [[ "$SDK_NAME" =~ ([A-Za-z]+) ]]
then
SF_SDK_PLATFORM=${BASH_REMATCH[1]}
else
echo "Could not find platform name from SDK_NAME: $SDK_NAME"
exit 1
fi

if [[ "$SF_SDK_PLATFORM" = "iphoneos" ]]
then
echo "Please choose iPhone simulator as the build target."
exit 1
fi

IPHONE_DEVICE_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphoneos
SIMULATOR_BUILD_DIR=${BUILD_DIR}/${CONFIGURATION}-iphonesimulator

# Build the other (non-simulator) platform
xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}" CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/arm64" SYMROOT="${SYMROOT}" ARCHS='arm64' VALID_ARCHS='arm64' $ACTION

xcodebuild -project "${PROJECT_FILE_PATH}" -target "${TARGET_NAME}" -configuration "${CONFIGURATION}" -sdk iphoneos BUILD_DIR="${BUILD_DIR}" OBJROOT="${OBJROOT}" BUILD_ROOT="${BUILD_ROOT}"  CONFIGURATION_BUILD_DIR="${IPHONE_DEVICE_BUILD_DIR}/armv7" SYMROOT="${SYMROOT}" ARCHS='armv7 armv7s' VALID_ARCHS='armv7 armv7s' $ACTION

# Copy the framework structure to the universal folder (clean it first)
rm -rf "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}/dSYMs/armv7/"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}/dSYMs/arm64/"
mkdir -p "${UNIVERSAL_OUTPUTFOLDER}/dSYMs/iphonesimulator/"

cp -R "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework" "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework"

# Smash them together to combine all architectures
lipo -create  "${BUILD_DIR}/${CONFIGURATION}-iphonesimulator/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/arm64/${TARGET_NAME}.framework/${TARGET_NAME}" "${BUILD_DIR}/${CONFIGURATION}-iphoneos/armv7/${TARGET_NAME}.framework/${TARGET_NAME}" -output "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework/${TARGET_NAME}"

rm -rf "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework/PrivateHeaders"
cp -R "${IPHONE_DEVICE_BUILD_DIR}/armv7/${TARGET_NAME}.framework/Modules" "${UNIVERSAL_OUTPUTFOLDER}/${TARGET_NAME}.framework/Modules"
#copy dsym files
cp -R "${IPHONE_DEVICE_BUILD_DIR}/armv7/${TARGET_NAME}.framework.dSYM" "${UNIVERSAL_OUTPUTFOLDER}/dSYMs/armv7/"
cp -R "${IPHONE_DEVICE_BUILD_DIR}/arm64/${TARGET_NAME}.framework.dSYM" "${UNIVERSAL_OUTPUTFOLDER}/dSYMs/arm64/"
cp -R "${SIMULATOR_BUILD_DIR}/${TARGET_NAME}.framework.dSYM" "${UNIVERSAL_OUTPUTFOLDER}/dSYMs/iphonesimulator/"
