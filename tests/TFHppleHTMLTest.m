//
//  TFHppleHTMLTest.m
//  Hpple
//
//  Created by Zach Waugh on 2/21/14.
//
//

#import <XCTest/XCTest.h>
#import "TFHpple.h"

@interface TFHppleHTMLTest : XCTestCase

@property (nonatomic, strong) TFHpple *doc;

@end

@implementation TFHppleHTMLTest

- (void)setUp
{
    [super setUp];
	NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"index" ofType:@"html"]];
	self.doc = [[TFHpple alloc] initWithHTMLData:data];
}

- (void)tearDown
{
	self.doc = nil;
    [super tearDown];
}

- (void)testInitializesWithHTMLData
{
  XCTAssertNotNil(self.doc.data);
  XCTAssertEqualObjects([self.doc.class description], @"TFHpple");
}

//  doc.search("//p[@class='posted']")
- (void)testSearchesWithXPath
{
  NSArray *a = [self.doc searchWithXPathQuery:@"//a[@class='sponsor']"];
  XCTAssertTrue(a.count == 2);
	
  TFHppleElement *e = a[0];
  XCTAssertEqualObjects([e.class description], @"TFHppleElement");
}

- (void)testFindsFirstElementAtXPath
{
  TFHppleElement *e = [self.doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];
	
  XCTAssertEqualObjects(e.text, @"RailsMachine");
  XCTAssertEqualObjects(e.tagName, @"a");
}

- (void)testSearchesByNestedXPath
{
  NSArray *a = [self.doc searchWithXPathQuery:@"//div[@class='column']//strong"];
  XCTAssertTrue(a.count == 5);
  
  TFHppleElement * e = a[0];
  XCTAssertEqualObjects(e.text, @"PeepCode");
}

- (void)testPopulatesAttributes
{
  TFHppleElement *e = [self.doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];
  
  XCTAssertTrue([e.attributes isKindOfClass:[NSDictionary class]]);
  XCTAssertEqualObjects([[e attributes] objectForKey:@"href"], @"http://railsmachine.com/");
}

- (void)testProvidesEasyAccessToAttributes
{
  TFHppleElement *e = [self.doc peekAtSearchWithXPathQuery:@"//a[@class='sponsor']"];
  
  XCTAssertEqualObjects([e objectForKey:@"href"], @"http://railsmachine.com/");
}
	
@end
