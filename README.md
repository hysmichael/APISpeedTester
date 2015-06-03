## API Speed Tester
A simple iOS app to test API request speed.

##### Two additional files are required for the app to compile and run. These two files should be created and placed in the project directory.

###### (1) Setting.h

Base URL that all API calls are relative to:
```
static NSString *baseURLString = BASE_URL_STRING;
```

An absolute or relative URL for submitting the final report in JSON format:
```
static NSString *reportSubmitURL = REPORT_SUBMIT_URL;
```

User token for authorization purposes:
```
static NSString *userToken = USER_TOKEN;
```

Default request time out tolerance:
```
static NSTimeInterval requestTimeOut = REQUEST_TIMEOUT;
```

###### (2) Data.m
All test cases must be added to the test queue by implementing TestData category on ViewController.
```
#import "ViewController.h"
#import "STTestCase.h"
#import "STTestQueue.h"

@implementation ViewController (TestData)

- (void) setUpTestQueue:(STTestQueue *)queue

@end 
```



