# ZRTasking
Simple NSTask wrapper to run shell command synchronously or asynchronously

## Usage

#### Run command synchronously
```objective-c
  int status;
  NSData* result = runCommandSync(@"/usr/bin/curl -fsSL taobao.com", YES, &status);
  NSLog(@"data length: %ld, status: %d", [result length], status);
```

#### Run command asynchronously
```objective-c
  runCommandAsnyc(@"/usr/bin/curl -fsSL taobao.com", YES, ^(NSData * _Nonnull data, int exitStatus) {
      NSLog(@"data length: %ld, status: %d", [data length], exitStatus);
  });
```
