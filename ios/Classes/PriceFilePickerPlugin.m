#import "PriceFilePickerPlugin.h"
#if __has_include(<price_file_picker/price_file_picker-Swift.h>)
#import <price_file_picker/price_file_picker-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "price_file_picker-Swift.h"
#endif

@implementation PriceFilePickerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPriceFilePickerPlugin registerWithRegistrar:registrar];
}
@end
