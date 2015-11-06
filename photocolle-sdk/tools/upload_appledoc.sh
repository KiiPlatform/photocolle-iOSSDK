#!/bin/sh


BRANCH_NAME=`git rev-parse --abbrev-ref HEAD`
COMMIT_ID=`git rev-parse --short HEAD`
ZIP_NAME="PhotoColleSDK-iOS-appledoc-${BRANCH_NAME}-${COMMIT_ID}.zip"

pushd target
mv apiDoc PhotoColleSDK-iOS-appledoc
zip -r ${ZIP_NAME} PhotoColleSDK-iOS-appledoc
aws s3 cp ${ZIP_NAME}  s3://com.kii.dev.jp.clientteam/
popd
