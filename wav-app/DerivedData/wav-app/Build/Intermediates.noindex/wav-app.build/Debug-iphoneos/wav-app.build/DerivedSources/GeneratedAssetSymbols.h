#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "AppleIcon" asset catalog image resource.
static NSString * const ACImageNameAppleIcon AC_SWIFT_PRIVATE = @"AppleIcon";

/// The "GoogleIcon" asset catalog image resource.
static NSString * const ACImageNameGoogleIcon AC_SWIFT_PRIVATE = @"GoogleIcon";

#undef AC_SWIFT_PRIVATE
