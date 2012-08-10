//
//  Analytics.m
//  T2TB
//
//  Created by robbiev on 11/3/10.
//  Copyright 2010 National Center for Telehealth & Technology. All rights reserved.
//

#import "Analytics.h"
#import "FlurryAPI.h"

static BOOL ANALYTICS_ENABLED = YES;
static BOOL SESSION_STARTED = NO;
static NSString *API_KEY = @"";

@implementation Analytics

+ (void)init:(NSString *)apiKey isEnabled:(BOOL)enabled {
	API_KEY = apiKey;
	ANALYTICS_ENABLED = enabled;
	
	if(ANALYTICS_ENABLED) {
		SESSION_STARTED = YES;
		//[FlurryAPI startSessionWithLocationServices:API_KEY];
		[FlurryAPI startSession:API_KEY];
	}
}

+ (void)setEnabled:(BOOL)enabled {
	ANALYTICS_ENABLED = enabled;
	
	if(ANALYTICS_ENABLED && !SESSION_STARTED) {
		SESSION_STARTED = YES;
		//[FlurryAPI startSessionWithLocationServices:API_KEY];
		[FlurryAPI startSession:API_KEY];
	}
}


+ (void)logEvent:(NSString *)eventName {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI logEvent:eventName];
	}
}

+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI logEvent:eventName withParameters:parameters];
	}
}

+ (void)logError:(NSString *)errorID message:(NSString *)message exception:(NSException *)exception {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI logError:errorID message:message exception:exception];
	}
}

+ (void)logError:(NSString *)errorID message:(NSString *)message error:(NSError *)error {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI logError:errorID message:message error:error];
	}
}

+ (void)logEvent:(NSString *)eventName timed:(BOOL)timed {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI logEvent:eventName timed:timed];
	}
}

+ (void)logEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters timed:(BOOL)timed {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI logEvent:eventName withParameters:parameters timed:timed];
	}
}

+ (void)endTimedEvent:(NSString *)eventName withParameters:(NSDictionary *)parameters {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI endTimedEvent:eventName withParameters:parameters];
	}
}

+ (void)countPageViews:(id)target {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI countPageViews:target];
	}
}

+ (void)countPageView {
	if(ANALYTICS_ENABLED) {
		[FlurryAPI countPageView];
	}
}


@end
