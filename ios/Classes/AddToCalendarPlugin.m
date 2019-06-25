#import "AddToCalendarPlugin.h"
#import <add_to_calendar/add_to_calendar-Swift.h>

@implementation AddToCalendarPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAddToCalendarPlugin registerWithRegistrar:registrar];
}
@end
