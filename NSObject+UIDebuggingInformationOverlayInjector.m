@import UIKit;
@import Foundation;
@import ObjectiveC.runtime;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
#pragma clang diagnostic ignored "-Wundeclared-selector"
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@interface NSObject()
- (void)_setWindowControlsStatusBarOrientation:(BOOL)orientation;
@end

@interface UIDebuggingInformationOverlayWindow : UIWindow
@end

@implementation UIDebuggingInformationOverlayWindow

- (instancetype)initSwizzled
{
  if (self= [super init]) {
    [self _setWindowControlsStatusBarOrientation:NO];
  }
  return self;
}

@end

@implementation NSObject (UIDebuggingInformationOverlayInjector)

+ (void)load
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    Class cls = NSClassFromString(@"UIDebuggingInformationOverlay");
    NSAssert(cls, @"DBG Class is nil?");
    
    // Swizzle code here
    [UIDebuggingInformationOverlayWindow swizzleOriginalSelector:@selector(init) withSizzledSelector:@selector(initSwizzled) forClass:cls isClassMethod:NO];
    
    [self swizzleOriginalSelector:@selector(prepareDebuggingOverlay) withSizzledSelector:@selector(prepareDebuggingOverlaySwizzled) forClass:cls isClassMethod:YES];
  });
}

+ (void)swizzleOriginalSelector:(SEL)originalSelector withSizzledSelector:(SEL)swizzledSelector forClass:(Class)class isClassMethod:(BOOL)isClassMethod
{
  
  Method originalMethod;
  Method swizzledMethod;
  
  if (isClassMethod) {
    originalMethod = class_getClassMethod(class, originalSelector);
    swizzledMethod = class_getClassMethod([self class], swizzledSelector);
  } else {
    originalMethod = class_getInstanceMethod(class, originalSelector);
    swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
  }
  
  NSAssert(originalMethod, @"originalMethod should not be nil");
  NSAssert(swizzledMethod, @"swizzledMethod should not be nil");
  
  method_exchangeImplementations(originalMethod, swizzledMethod);
}

+ (void)prepareDebuggingOverlaySwizzled {
    id overlayClass = NSClassFromString(@"UIDebuggingInformationOverlayInvokeGestureHandler");
    id handler = [overlayClass performSelector:NSSelectorFromString(@"mainHandler")];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:handler action:@selector(_handleActivationGesture:)];
    tapGesture.numberOfTouchesRequired = 2;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.delegate = handler;
    UIView *statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    [statusBarWindow addGestureRecognizer:tapGesture];
}

/* For simulator
+ (void)prepareDebuggingOverlaySwizzled {

  Class cls = NSClassFromString(@"UIDebuggingInformationOverlay");
  SEL sel = @selector(prepareDebuggingOverlaySwizzled);
  Method m = class_getClassMethod(cls, sel);

  IMP imp =  method_getImplementation(m);
  void (*methodOffset) = (void *)((imp + (long)27));
  void *returnAddr = &&RETURNADDRESS;

  __asm__ __volatile__(
      "pushq  %0\n\t"
      "pushq  %%rbp\n\t"
      "movq   %%rsp, %%rbp\n\t"
      "pushq  %%r15\n\t"
      "pushq  %%r14\n\t"
      "pushq  %%r13\n\t"
      "pushq  %%r12\n\t"
      "pushq  %%rbx\n\t"
      "pushq  %%rax\n\t"
      "jmp  *%1\n\t"
      :
      : "r" (returnAddr), "r" (methodOffset));

  RETURNADDRESS: ;
}
 */

@end
#pragma clang diagnostic pop
