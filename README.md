# UIDebuggingInformationOverlay
iOS11 UIDebuggingInformationOverlay

### Usage:

Tap the status bar with two fingertip simultaneously to trigger UIDebuggingInformationOverlay

```
#if DEBUG
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlay");
        [overlayClass performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
#pragma clang diagnostic pop
#endif
```

### Reference:

1. [Swizzling in iOS 11 with UIDebuggingInformationOverlay](https://www.raywenderlich.com/177890/swizzling-in-ios-11-with-uidebugginginformationoverlay)
2. [iOS自带悬浮窗调试工具使用详解](https://wellphone.me/post/2017/use_uidebugginginformationoverlay_to_debug_ui/)
3. [在iOS11上使用自带悬浮窗工具调试UI](https://wellphone.me/post/2017/use_uidebugginginformationoverlay_for_ios11/)
