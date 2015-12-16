# TODO: version number should be extract from photocolle-sdk.framework/Resources/info.plist
VERSION=1.0.0
APPLEDOC=../tools/appledoc/bin/appledoc
DOCOUTPUTDIR=target/apiDoc
APPLEDOCTEMPLATE=../tools/appledoc/template/
SDKNAME=PhotoColleSDK
TESTRESULTDIR=test-results
APPOUTDIR=target/app
TEST_MACROS='OUTDIR=\"$(PWD)/$(TESTRESULTDIR)\"'

all:framework doc

upload-doc: clean doc
	sh tools/upload_appledoc.sh

doc:
	mkdir -p $(DOCOUTPUTDIR);
	$(APPLEDOC) -o $(DOCOUTPUTDIR) -t $(APPLEDOCTEMPLATE) -p $(SDKNAME) -c "Kii Corp" \
	--no-create-docset --no-repeat-first-par --create-html photocolle-sdk/include/
	zip target/$(SDKNAME)-iOS-$(VERSION)_API_doc.zip -r $(DOCOUTPUTDIR)

framework:
	sh photocolle-sdk.framework/generate_framework.sh

test: new-test

new-test:
	osascript -e 'tell app "iPhone Simulator" to quit'
	rm -rf $(TESTRESULTDIR)
	mkdir $(TESTRESULTDIR)
	xcodebuild -configuration Debug -arch i386 -sdk iphonesimulator -target GHUnitTests clean install DSTROOT=$(APPOUTDIR) GCC_PREPROCESSOR_DEFINITIONS=$(TEST_MACROS)
	ios-sim launch $(APPOUTDIR)/Applications/GHUnitTests.app --devicetypeid com.apple.CoreSimulator.SimDeviceType.iPhone-6
	osascript -e 'tell app "iPhone Simulator" to quit'

old-test:
	rm -rf $(TESTRESULTDIR)
	mkdir $(TESTRESULTDIR)
	WRITE_JUNIT_XML=YES JUNIT_XML_DIR=$(TESTRESULTDIR) GHUNIT_CLI=1 xcodebuild  -target GHUnitTests -configuration Debug -sdk iphonesimulator7.0 clean build

clean:
	rm -rf target
	rm -rf build
