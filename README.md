## API Speed Tester
A simple iOS app to test API request speed.

##### Two additional files are required for the app to compile and run.
###### (1) Setting.h

/* base URL that all API calls are relative to */
```
static NSString *baseURLString = BASE_URL_STRING;
```

/* an absolute or relative URL for submitting the final report in JSON format */
```
static NSString *reportSubmitURL = REPORT_SUBMIT_URL;
```

/* user token for authorization purposes */
```
static NSString *userToken = USER_TOKEN;
```

/* default time out tolerance */
```
static NSTimeInterval requestTimeOut = REQUEST_TIMEOUT;
```

###### (2) Data.m
All test cases must be added to the test queue.
```
- (void) setUpTestQueue:(STTestQueue *)queue 
```



