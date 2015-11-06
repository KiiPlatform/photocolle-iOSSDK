#import <GHUnitIOS/GHUnit.h>
#import <GHUnitIOS/GHTesting.h>
#import "GHUnitTestAppDegelate.h"

#ifndef OUTDIR
    #define OUTDIR NULL
#endif

void exceptionHandler(NSException *exception) {
    NSLog(@"%@\n%@", [exception reason], [GHTesting descriptionForException:exception]);
}

int main(int argc, char *argv[]) {
    NSSetUncaughtExceptionHandler(&exceptionHandler);

    int retVal = 0;
    if (getenv("GHUNIT_CLI")) {
        retVal = [GHTestRunner run];
    } else {
        if (OUTDIR != NULL) {
            setenv("GHUNIT_AUTORUN" , "YES", 1);
            setenv("WRITE_JUNIT_XML", "YES", 1);
            setenv("GHUNIT_AUTOEXIT", "YES", 1);
            setenv("JUNIT_XML_DIR", OUTDIR, 1);
        }
        retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([GHUnitTestAppDegelate class]));
    }

    return retVal;
}
