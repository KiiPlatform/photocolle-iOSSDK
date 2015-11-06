all: change-framework

change-framework:
	rm -rf test-app/PhotoColleSDK.framework
	(cd ../photocolle-sdk; make framework)
	cp -a ../photocolle-sdk/target/photocolle-sdk/PhotoColleSDK.framework test-app/
