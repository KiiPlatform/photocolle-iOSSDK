# ==========
# Variable settings
# ==========

FRAMEWORK_BASE_DIR='photocolle-sdk.framework'
INFOPLIST=${FRAMEWORK_BASE_DIR}'/Resources/Info.plist'
FRAMEWORK_NAME=$(/usr/libexec/PlistBuddy -c "Print CFBundleName" ${INFOPLIST})
BUILD_TARGET_NAME='photocolle-sdk'
FRAMEWORK_BUILD_CONFIGURATION="Release"
FRAMEWORK_VERSION_NUMBER=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${INFOPLIST})
FRAMEWORK_VERSION=A
FRAMEWORK_TARGET_DIR="target"
FRAMEWORK_BUILD_PATH="$FRAMEWORK_TARGET_DIR/photocolle-sdk"
FRAMEWORK_DIR="${FRAMEWORK_BUILD_PATH}/${FRAMEWORK_NAME}.framework"
PACKAGENAME="${FRAMEWORK_NAME}.${FRAMEWORK_VERSION_NUMBER}.zip"

# ==========
# Build
# ==========
xcodebuild -configuration ${FRAMEWORK_BUILD_CONFIGURATION} -target ${BUILD_TARGET_NAME} clean
xcodebuild -configuration ${FRAMEWORK_BUILD_CONFIGURATION} -target ${BUILD_TARGET_NAME} -sdk iphonesimulator${IPHONEOS_DEPLOYMENT_TARGET}
[ $? != 0 ] && exit 1
xcodebuild -configuration ${FRAMEWORK_BUILD_CONFIGURATION} -target ${BUILD_TARGET_NAME} -sdk iphoneos${IPHONEOS_DEPLOYMENT_TARGET}
[ $? != 0 ] && exit 1

# ==========
# make directories for framework
# ==========

[ -d "${FRAMEWORK_BUILD_PATH}" ] && rm -rf "${FRAMEWORK_BUILD_PATH}"
mkdir -p ${FRAMEWORK_BUILD_PATH}
mkdir -p ${FRAMEWORK_DIR}
mkdir -p ${FRAMEWORK_DIR}/Resources
mkdir -p ${FRAMEWORK_DIR}/Headers
mkdir -p ${FRAMEWORK_DIR}/Versions
mkdir -p ${FRAMEWORK_DIR}/Versions/${FRAMEWORK_VERSION}
mkdir -p ${FRAMEWORK_DIR}/Versions/Current

# ==========
# create framework
# ==========
lipo -create \
build/${FRAMEWORK_BUILD_CONFIGURATION}-iphoneos/lib${BUILD_TARGET_NAME}.a \
build/${FRAMEWORK_BUILD_CONFIGURATION}-iphonesimulator/lib${BUILD_TARGET_NAME}.a \
-o "${FRAMEWORK_DIR}/${FRAMEWORK_NAME}"

cp ${BUILD_TARGET_NAME}/include/*.h ${FRAMEWORK_DIR}/Headers/
cp ${FRAMEWORK_BASE_DIR}/Resources/* ${FRAMEWORK_DIR}/Resources/
cp ${FRAMEWORK_BASE_DIR}/README.mkd ${FRAMEWORK_BUILD_PATH}/
cp -r ${FRAMEWORK_DIR}/Headers ${FRAMEWORK_DIR}/Resources ${FRAMEWORK_DIR}/${FRAMEWORK_NAME} ${FRAMEWORK_DIR}/Versions/${FRAMEWORK_VERSION}/
cp -r ${FRAMEWORK_DIR}/Headers ${FRAMEWORK_DIR}/Resources ${FRAMEWORK_DIR}/${FRAMEWORK_NAME} ${FRAMEWORK_DIR}/Versions/Current/
chmod -fR 777 "${FRAMEWORK_DIR}"
cd ${FRAMEWORK_TARGET_DIR}
zip -ry ${PACKAGENAME} $(basename $FRAMEWORK_BUILD_PATH)
