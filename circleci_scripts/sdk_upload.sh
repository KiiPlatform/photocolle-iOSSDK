#!bin/bash

version=`grep 's\.version\s*=' PhotoColleSDK.podspec | sed -e 's/.*\([0-9]\.[0-9]\.[0-9]\).*/\1/g'`
sdk_body_file="target/PhotoColleSDK-iOS-$version.zip"

if [ -f "$sdk_body_file" ]; then

    echo "{ \"platform\" : \"ios\", \"sdk\" : \"photocolle\", \"type\" : \"sdk\", \"version\" : \"v$version\", \"extension\" : \"zip\"}" > sdk-metadata.json

    cd internal-tools/sdk-uploader

    sdk_meta_file=../../sdk-metadata.json
    sdk_body_file="../../$sdk_body_file"

    if [ "$SDK_DEST" = 'release' ]; then
        # release to kii cloud server
        echo "release to kii cloud..."
        python sdk_uploader.py --meta=$sdk_meta_file --file=$sdk_body_file --content-type=application/zip --kii-bucket=sdks

    elif [ "$SDK_DEST" = 'test' ]; then
        echo "test release..."
        python sdk_uploader.py --meta=$sdk_meta_file --file=$sdk_body_file --content-type=application/zip
    else
        echo "SDK_DEST should either release or test"
        exit 1
    fi
else
    echo "no release file found to upload. ($sdk_body_file)"
    exit 1
fi
