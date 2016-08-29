VERSION:=$(shell grep 's\.version\s*=' PhotoColleSDK.podspec | sed -e 's/.*\([0-9]\.[0-9]\.[0-9]\).*/\1/g')
TARGET=target
SDKNAME=PhotoColleSDK-iOS
PACKAGENAME=$(SDKNAME)
PACKAGEDIR=$(TARGET)/$(PACKAGENAME)
DISTRIBUTIONDIR=$(PACKAGEDIR)/distribution
DOCSDIR=docs
PHOTOCOLLEDIR=photocolle-sdk

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

copy: copy-framework copy-doc
	echo "Copy reference document."
	cp -a $(DOCSDIR)/REFERENCE_GUIDE.mkd $(DISTRIBUTIONDIR)/$(DOCSDIR)
	cp -a README.mkd $(DISTRIBUTIONDIR)/$(DOCSDIR)
	cp -a $(PHOTOCOLLEDIR)/LIMITATION.mkd $(DISTRIBUTIONDIR)/$(DOCSDIR)

copy-framework:
	cp -a $(PHOTOCOLLEDIR)/dist/PhotoColleSDK.framework $(DISTRIBUTIONDIR)/

copy-doc:
	echo "Copy headerdocs."
	cp -a $(PHOTOCOLLEDIR)/target/apiDoc $(DISTRIBUTIONDIR)/$(DOCSDIR)/$(SDKNAME)-API-Reference

remove-temp-files:
	find $(DISTRIBUTIONDIR) -name "*~" -exec rm -f {} \;

zip:
	echo "Compress files."
	(cd target; zip -r $(PACKAGENAME)-$(VERSION).zip $(PACKAGENAME))
