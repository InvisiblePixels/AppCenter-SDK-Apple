#import "MSChannelGroupProtocol.h"
#import "MSChannelUnitConfiguration.h"
#import "MSChannelUnitProtocol.h"
#import "MSCommonSchemaLog.h"
#import "MSOneCollectorChannelDelegatePrivate.h"

static NSString *const kMSOneCollectorGroupIdSuffix = @"/one";

@implementation MSOneCollectorChannelDelegate

- (id)init {
  self = [super init];
  if (self) {
    _oneCollectorChannels = [NSMutableDictionary new];
  }

  return self;
}

- (void)channelGroup:(id<MSChannelGroupProtocol>)channelGroup didAddChannelUnit:(id<MSChannelUnitProtocol>)channel {

  // Add OneCollector group based on the given channel's group id.
  NSString *groupId = channel.configuration.groupId;
  if (![self isOneCollectorGroup:groupId]) {
    NSString *oneCollectorGroupId =
        [NSString stringWithFormat:@"%@%@", channel.configuration.groupId, kMSOneCollectorGroupIdSuffix];
    MSChannelUnitConfiguration *channelUnitConfiguration =
        [[MSChannelUnitConfiguration alloc] initDefaultConfigurationWithGroupId:oneCollectorGroupId];

    // TODO need to figure out actual sender for One Collector
    id<MSChannelUnitProtocol> channelUnit =
        [channelGroup addChannelUnitWithConfiguration:channelUnitConfiguration withSender:nil];
    self.oneCollectorChannels[groupId] = channelUnit;
  }
}

- (void)channel:(id<MSChannelProtocol>)__unused channel prepareLog:(id<MSLog>)log{
  
  // Prepare Common Schema logs.
  if ([log isKindOfClass:[MSCommonSchemaLog class]]){
    
    // Add epoch and seq.
    
  }
}

- (BOOL)shouldFilterLog:(id<MSLog>)__unused log {
  return NO;
}

- (void)channel:(id<MSChannelProtocol>)channel
              didSetEnabled:(BOOL)isEnabled
    andDeleteDataOnDisabled:(BOOL)deletedData {
  if ([channel conformsToProtocol:@protocol(MSChannelUnitProtocol)]) {
    NSString *groupId = ((id<MSChannelUnitProtocol>)channel).configuration.groupId;
    if (![self isOneCollectorGroup:groupId]) {
      [self.oneCollectorChannels[groupId] setEnabled:isEnabled andDeleteDataOnDisabled:deletedData];
    }
  }
}

- (BOOL)isOneCollectorGroup:(NSString *)groupId {
  return [groupId hasSuffix:kMSOneCollectorGroupIdSuffix];
}

@end
