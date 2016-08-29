#! bin/bash

git clone git@github.com:KiiPlatform/photocolle-iOSSDK.git RepoForDoc

cd RepoForDoc
git checkout gh-pages
git rm -r docs/
cp -rf ../target/PhotoColleSDK-iOS/distribution/docs/PhotoColleSDK-iOS-API-Reference/html docs
git add docs
git commit -m "update api doc"
git push origin gh-pages

