//
//  Event.m
//  AnyXML
//
//  Created by Helge Städtler on 26.12.10.
//  Copyright 2010 staedtler development. All rights reserved.
//

#import "Event.h"
#import "RegexKitLite.h"
#import "MasterConfig.h"
#import "NSString-Toolkit.h"
#import "FavouriteManager.h"

@implementation Event

@synthesize eventId;
@synthesize duration;
@synthesize start;
@synthesize timeHour;
@synthesize timeMinute;
@synthesize type;
@synthesize room;
@synthesize slug;
@synthesize title;	
@synthesize subtitle;
@synthesize track;
@synthesize language;
@synthesize abstract;
@synthesize descriptionText;
@synthesize persons;
@synthesize links;
@synthesize day;


- (void) dealloc {
	[start release];
	[room release];
	[slug release];
	[title release];
	[subtitle release];
	[track release];
	[language release];
	[abstract release];
	[descriptionText release];
	[persons release];
	[links release];
    self.day = nil;
	[super dealloc];
}

- (id)init {
    if (self = [super init]) {
        // Initialization code
		self.eventId = -1;
		self.title = @"Unknown";
        self.persons = [NSMutableArray array];
        self.links = [NSMutableArray array];
    }
    return self;
}

- (NSString*) imageName {
    return [NSString stringWithFormat:@"event-%i-128x128.png", eventId];
}

- (NSString*) pngIconHref {
    NSString *imageTemplateUrl = [[MasterConfig sharedConfiguration] urlStringForKey:kURL_KEY_29C3_EVENTS];
    imageTemplateUrl = [imageTemplateUrl stringByReplacingOccurrencesOfString:@"$id$" withString:[self eventIdKey]];
    return imageTemplateUrl;
}

- (NSString*) eventIdKey {
    return [NSString stringWithFormat:@"%i", eventId];
}

- (void) addPerson:(Person*)personToAdd {
    [persons addObject:personToAdd];
}

- (void) addLink:(Link*)linkToAdd {
    [links addObject:linkToAdd];
}

- (NSString*) localizedLanguageName {
    return LOC( self.language );
}

- (NSString*) speakerList {
    NSMutableString *listString = [NSMutableString string];
    for( Person *currentPerson in [self persons] ) {
        BOOL needsComma = ( [listString length] > 0 );
        [listString appendFormat:@"%@%@", needsComma ? @", " : @"", currentPerson.personName];
    }
    return listString;
}

- (NSString*) stringRepresentationMail {
    return [NSString stringWithFormat:@"<b>%@</b><br>%@", [NSString placeHolder:@"(Kein Titel)" forEmptyString:title], [NSString placeHolder:@"(Kein Untertitel)" forEmptyString:subtitle]];
}

- (NSString*) stringRepresentationTwitter {
    Link *firstLink = nil;
    if( links && [links count] > 0 ) {
        firstLink = [links objectAtIndex:0];
    }
    NSString *linkHref = [firstLink.href httpUrlString];
    return [NSString stringWithFormat:@"\"%@\" %@", [NSString placeHolder:@"(Kein Titel)" forEmptyString:title], [NSString placeHolder:@"" forEmptyString:linkHref]];
}

- (NSString*) description {
	NSMutableString *stringRepresentation = [NSMutableString string];
	[stringRepresentation appendFormat:@"EVENT (%i)\n", eventId];
	[stringRepresentation appendFormat:@"title = %@\n", title == nil ? @"[NIL]" : title];
	[stringRepresentation appendFormat:@"subtitle = %@\n", subtitle == nil ? @"[NIL]" : subtitle];
	[stringRepresentation appendFormat:@"room = %@\n", room == nil ? @"[NIL]" : room];
	[stringRepresentation appendFormat:@"track = %@\n", track == nil ? @"[NIL]" : track];
	[stringRepresentation appendFormat:@"language = %@\n", language == nil ? @"[NIL]" : language];
	[stringRepresentation appendFormat:@"room = %@\n", room == nil ? @"[NIL]" : room];
	[stringRepresentation appendFormat:@"start = %@\n", start == nil ? @"[NIL]" : start];
	[stringRepresentation appendFormat:@"duration = %f\n", duration == 0 ? -1.0f : duration];
	[stringRepresentation appendFormat:@"icon = %@\n", [self pngIconHref]];
	[stringRepresentation appendFormat:@"persons:\n%@", [persons count] ? persons : @"[NONE]"];
	[stringRepresentation appendFormat:@"links:\n%@", [links count] ? links : @"[NONE]"];
	[stringRepresentation appendFormat:@"\n\n"];
	return stringRepresentation;
}

- (void) takeDurationFromString:(NSString*)durationString { //  <duration>01:00</duration>
	// step 1: create parts of strings
	NSArray *durationComponents = [durationString componentsSeparatedByString:@":"];
	// step 2: calculate timeinterval in minutes
	int hours, minutes, seconds = 0;
	int i = 0;
	for( NSString* currentComponent in durationComponents ) {
		i++;
		switch( i ) {
			case 1:
				hours = [currentComponent intValue];
				break;
			case 2:
				minutes = [currentComponent intValue];
				break;
			case 3:
				seconds = [currentComponent intValue];
				break;
			default:
				break;
		}
	}
	self.duration = (NSTimeInterval)[[NSNumber numberWithInt:(hours+minutes)] doubleValue];
}

- (void) takeStartDateTimeFromString:(NSString*)dateString {
    self.start = [dateString trimmedString];
    NSString *regex = @"[0-9]{2}:[0-9]{2}";
	NSArray *matchesArray = [dateString componentsMatchedByRegex:regex];
    NSString *timeString = nil;
    NSArray *timeComponents = nil;
    if( [matchesArray count] > 0 ) {
        timeString = [matchesArray objectAtIndex:0];
        timeComponents = [timeString componentsSeparatedByString:@":"];
    }
    self.timeHour = [[timeComponents objectAtIndex:0] integerValue];
	self.timeMinute = [[timeComponents objectAtIndex:1]  integerValue];
}

- (void) takeValuesFromDictionary:(NSDictionary*)dict {
	// NSString *className = nil;
	// className = [someObject isKindOfClass:[NSDictionary class]] ? @"NSDictionary" : @"no dict";
	// NSLog( @"allkeys = %@", [dict allKeys]  );
	if( [dict valueForKey:@"nodeName"] == nil ) return;
	NSString *attributeValue = nil;
	@try {
		attributeValue = [dict valueForKey:@"nodeAttributeArray"];
		
	}
	@catch (NSException * e) {
		// do nothing
	}
	@finally {
		// do noting
	}
}

+ (NSMutableArray*) completeEventListFromArray:(NSArray*)array withFetchLimit:(int)limitValue {
	Event *createdEvent = nil;
	NSMutableArray *listCreated = [NSMutableArray array];
	NSDictionary *currentDict = nil;
	for( int i = 0; i < [array count]; i++ ) {
		currentDict = (NSDictionary*) [array objectAtIndex:i];
		createdEvent = [[Event alloc] init];
		[createdEvent takeValuesFromDictionary:currentDict];
		[listCreated addObject:createdEvent];
	}
	return listCreated;
}

// SEARCHABLE ITEM

- (NSString*) itemId {
    return [NSString stringWithFormat:@"%i", [self eventId]];
}

- (NSString*) itemTitle {
    return title;
}

- (NSString*) itemSubtitle {
    return subtitle;
}
- (NSString*) itemAbstract {
    return descriptionText;
}

- (NSString*) itemPerson {
    NSMutableString *personsString = [NSMutableString string];
    BOOL isFirst = YES;
    for( Person* currentPerson in persons ) {
        [personsString appendFormat:@"%@%@", isFirst ? @"" : @",", currentPerson.personName];
        isFirst = NO;
    }
    return personsString;
}

- (NSDate*) itemDateStart {
    // TODO: calculate date from day & self.timeHour self.timeMinute
    return nil;
}

- (NSDate*) itemDateEnd {
    // TODO: calculate date from day & self.timeHour self.timeMinute
    return nil;
}

- (BOOL) isFavourite {
    return [[FavouriteManager sharedManager] hasStoredFavourite:self];
}

- (NSTimeInterval) itemSortNumberDateTime {
    // we have the day
    // we have hour start and minute
    return 0.0f;
}

@end
