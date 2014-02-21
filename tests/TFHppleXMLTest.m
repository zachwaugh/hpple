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
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
	self.doc = nil;
}

- (void)testInitializesWithXMLData
{
	XCTAssertNotNil(self.doc.data);
	XCTAssertEqualObjects([self.doc.class description], @"TFHpple");
}

//  item/title,description,link
- (void)testSearchesWithXPath
{
	NSArray *items = [self.doc searchWithXPathQuery:@"//item"];
	XCTAssertTrue(items.count == 15);

	TFHppleElement *e = items[0];
	XCTAssertEqualObjects([e.class description], @"TFHppleElement");
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
