//
//  TFHppleXMLTest.m
//  Hpple
//
//  Created by Zach Waugh on 2/21/14.
//
//

#import <XCTest/XCTest.h>
#import "TFHpple.h"

@interface TFHppleXMLTest : XCTestCase

@property (nonatomic, strong) TFHpple *doc;

@end

@implementation TFHppleXMLTest

- (void)setUp
{
    [super setUp];
	
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"feed" ofType:@"rss"]];
	self.doc = [[TFHpple alloc] initWithXMLData:data];
}

- (void)tearDown
{
    self.doc = nil;
	[super tearDown];
}

- (void)testInitializesWithXMLData
{
	XCTAssertNotNil(self.doc.data);
	XCTAssertTrue([self.doc isKindOfClass:[TFHpple class]]);
}

- (void)testFindsTitle
{
	NSArray *elements = [self.doc searchWithXPathQuery:@"/rss/channel/title"];
	XCTAssertNotNil(elements);
	XCTAssertTrue(elements.count == 1);
	
	TFHppleElement *element = elements[0];
	XCTAssertEqualObjects(element.tagName, @"title");
	XCTAssertEqualObjects(element.text, @"PeepCode Products");
}

- (void)testFindsAllTitles
{
	NSArray *elements = [self.doc searchWithXPathQuery:@"//title"];
	XCTAssertNotNil(elements);
	XCTAssertTrue(elements.count == 16);
	
	TFHppleElement *element = elements[0];
	XCTAssertEqualObjects(element.tagName, @"title");
	XCTAssertEqualObjects(element.text, @"PeepCode Products");
}

//  item/title,description,link
- (void)testSearchesWithXPath
{
	NSArray *items = [self.doc searchWithXPathQuery:@"//item"];
	XCTAssertTrue(items.count == 15);

	TFHppleElement *e = items[0];
	XCTAssertTrue([e isKindOfClass:[TFHppleElement class]]);
}

- (void)testFindsFirstElementAtXPath
{
	TFHppleElement *e = [self.doc peekAtSearchWithXPathQuery:@"//item/title"];
	
	XCTAssertEqualObjects(e.text, @"Objective-C for Rubyists");
	XCTAssertEqualObjects(e.tagName, @"title");
}

- (void)testSearchesByNestedXPath
{
	NSArray *elements = [self.doc searchWithXPathQuery:@"//item/title"];
	XCTAssertTrue(elements.count == 15);

	TFHppleElement *e = elements[0];
	XCTAssertEqualObjects(e.text, @"Objective-C for Rubyists");
}

- (void)testAtSafelyReturnsNilIfEmpty
{
	TFHppleElement *e = [self.doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];
	XCTAssertNil(e);
}

@end
