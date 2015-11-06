# TODO: version number should be extract from phophotocolle-sdk/photocolle-sdk.framework/Resources/info.plist
VERSION=1.1.0
TARGET=target
SDKNAME=PhotoColleSDK-iOS
PACKAGENAME=$(SDKNAME)-$(VERSION)
PACKAGEDIR=$(TARGET)/$(PACKAGENAME)
DISTRIBUTIONDIR=$(PACKAGEDIR)/distribution
DOCSDIR=docs
FRAMEWORKZIP=PhotoColleSDK.$(VERSION).zip
PHOTOCOLLEDIR=photocolle-sdk
TESTAPPDIR=test-app

release: clean init doc framework copy remove-temp-files zip
	echo "Creating release package was finished."

doc:
	echo "Make headerdocs."
	(cd photocolle-sdk; make doc)

framework:
	echo "Make photocolle-sdk framework."
	(cd photocolle-sdk; make framework)

clean: clean-sdk
	echo "Clean target directory."
	rm -rf $(TARGET)

clean-sdk:
	echo "Clean photocolle-sdk."
	(cd photocolle-sdk; make clean)

init:
	echo "Creating package directory."
	mkdir -p $(PACKAGEDIR)
	mkdir -p $(DISTRIBUTIONDIR)/$(DOCSDIR)
	mkdir -p $(PACKAGEDIR)/$(PHOTOCOLLEDIR)/photocolle-sdk.xcodeproj

copy: copy-framework copy-framework-source copy-doc copy-app
	echo "Copy reference document."
	cp -a $(DOCSDIR)/REFERENCE_GUIDE.mkd $(DISTRIBUTIONDIR)/$(DOCSDIR)
	cp -a README.mkd $(DISTRIBUTIONDIR)/$(DOCSDIR)
	cp -a $(PHOTOCOLLEDIR)/LIMITATION.mkd $(DISTRIBUTIONDIR)/$(DOCSDIR)
	cp -a $(PHOTOCOLLEDIR)/photocolle-sdk/ext/gtm/OAuth2/DCOAuth2View.xib $(DISTRIBUTIONDIR)

copy-framework:
	cp -a $(PHOTOCOLLEDIR)/target/photocolle-sdk/PhotoColleSDK.framework $(DISTRIBUTIONDIR)/

copy-framework-source:
	echo "Copy framework sources."
	mkdir -p $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
# copy required files.
	cp -a $(PHOTOCOLLEDIR)/Makefile $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/README.mkd $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/LIMITATION.mkd $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/photocolle-sdk $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/photocolle-sdk.framework $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/photocolle-sdkTests $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/test-app $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/test-appTests $(PACKAGEDIR)/$(PHOTOCOLLEDIR)
	cp -a $(PHOTOCOLLEDIR)/photocolle-sdk.xcodeproj/project.pbxproj $(PACKAGEDIR)/$(PHOTOCOLLEDIR)/photocolle-sdk.xcodeproj
# remove setting files
	rm -f $(PACKAGEDIR)/$(PHOTOCOLLEDIR)/test-app/photocolle_sdk_setting.plist
	rm -f $(PACKAGEDIR)/$(PHOTOCOLLEDIR)/test-app/photocolle_setting.plist
# copy dummy setting files
	cp -a $(DOCSDIR)/photocolle_sdk_setting.plist $(PACKAGEDIR)/$(PHOTOCOLLEDIR)/test-app/photocolle_sdk_setting.plist
	cp -a $(DOCSDIR)/photocolle_setting.plist $(PACKAGEDIR)/$(PHOTOCOLLEDIR)/test-app/photocolle_setting.plist

copy-doc:
	echo "Copy headerdocs."
	cp -a $(PHOTOCOLLEDIR)/target/apiDoc $(DISTRIBUTIONDIR)/$(DOCSDIR)/$(SDKNAME)-API-Reference

copy-app:
	echo "Copy test application."
# copy required files.
	mkdir -p $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app.xcodeproj/
	cp -a $(TESTAPPDIR)/README.mkd $(DISTRIBUTIONDIR)/$(TESTAPPDIR)
	cp -a $(TESTAPPDIR)/ic_launcher.png $(DISTRIBUTIONDIR)/$(TESTAPPDIR)
	cp -a $(TESTAPPDIR)/ic_launcher@2x.png $(DISTRIBUTIONDIR)/$(TESTAPPDIR)
	cp -a $(TESTAPPDIR)/test-app $(DISTRIBUTIONDIR)/$(TESTAPPDIR)
	cp -a $(TESTAPPDIR)/test-app.xcodeproj/project.pbxproj $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app.xcodeproj/
# remove setting files.
	rm -f $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app/photocolle_sdk_setting.plist
	rm -f $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app/photocolle_setting.plist
# copy dummy setting files
	cp -a $(DOCSDIR)/photocolle_sdk_setting.plist $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app/photocolle_sdk_setting.plist
	cp -a $(DOCSDIR)/photocolle_setting.plist $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app/photocolle_setting.plist
# remove and copy framework
	rm -rf $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app/PhotoColleSDK.framework
	cp -a $(PHOTOCOLLEDIR)/target/photocolle-sdk/PhotoColleSDK.framework $(DISTRIBUTIONDIR)/$(TESTAPPDIR)/test-app/

remove-temp-files:
	find $(DISTRIBUTIONDIR) -name "*~" -exec rm -f {} \;

zip:
	echo "Compress files."
	(cd target; zip -r $(PACKAGENAME).zip $(PACKAGENAME))
