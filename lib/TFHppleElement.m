//
//  TFHppleElement.m
//  Hpple
//
//  Created by Geoffrey Grosenbach on 1/31/09.
//
//  Copyright (c) 2009 Topfunky Corporation, http://topfunky.com
//
//  MIT LICENSE
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "TFHppleElement.h"
#import "XPathQuery.h"

static NSString * const TFHppleNodeContentKey           = @"nodeContent";
static NSString * const TFHppleNodeNameKey              = @"nodeName";
static NSString * const TFHppleNodeChildrenKey          = @"nodeChildArray";
static NSString * const TFHppleNodeAttributeArrayKey    = @"nodeAttributeArray";
static NSString * const TFHppleNodeAttributeNameKey     = @"attributeName";

static NSString * const TFHppleTextNodeName            = @"text";

@interface TFHppleElement ()

@property (nonatomic, strong) NSDictionary *node;
@property (nonatomic, copy) NSString *encoding;
@property (nonatomic, assign) BOOL isXML;
@property (nonatomic, weak, readwrite) TFHppleElement *parent;

@end

@implementation TFHppleElement

- (id)initWithNode:(NSDictionary *)theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding
{
	self = [super init];
	if (!self) return nil;

    _isXML = isDataXML;
    _node = theNode;
    _encoding = theEncoding;

	return self;
}

+ (TFHppleElement *)hppleElementWithNode:(NSDictionary *)theNode isXML:(BOOL)isDataXML withEncoding:(NSString *)theEncoding
{
  return [[[self class] alloc] initWithNode:theNode isXML:isDataXML withEncoding:theEncoding];
}

#pragma mark -

- (NSString *)raw
{
    return self.node[@"raw"];
}

- (NSString *)content
{
	return self.node[TFHppleNodeContentKey];
}

- (NSString *)tagName
{
	return self.node[TFHppleNodeNameKey];
}

- (NSArray *)children
{
	NSMutableArray *children = [NSMutableArray array];
	for (NSDictionary *child in self.node[TFHppleNodeChildrenKey]) {
		TFHppleElement *element = [TFHppleElement hppleElementWithNode:child isXML:self.isXML withEncoding:self.encoding];
		element.parent = self;
		[children addObject:element];
	}

	return children;
}

- (TFHppleElement *)firstChild
{
	NSArray *children = self.children;
	if (children.count > 0) {
		return children[0];
	}
    
	return nil;
}

- (NSDictionary *)attributes
{
  NSMutableDictionary *translatedAttributes = [NSMutableDictionary dictionary];
  for (NSDictionary *attributeDict in self.node[TFHppleNodeAttributeArrayKey]) {
      if ([attributeDict objectForKey:TFHppleNodeContentKey] && [attributeDict objectForKey:TFHppleNodeAttributeNameKey]) {
          [translatedAttributes setObject:[attributeDict objectForKey:TFHppleNodeContentKey]
                                   forKey:[attributeDict objectForKey:TFHppleNodeAttributeNameKey]];
      }
  }
	
  return translatedAttributes;
}

- (NSString *)objectForKey:(NSString *)theKey
{
	return self.attributes[theKey];
}

- (id)description
{
	return [self.node description];
}

- (BOOL)hasChildren
{
    if (self.node[TFHppleNodeChildrenKey]) {
		return YES;
	} else {
		return NO;
	}
}

- (BOOL)isTextNode
{
    // we must distinguish between real text nodes and standard nodes with tha name "text" (<text>)
    // real text nodes must have content
    if ([self.tagName isEqualToString:TFHppleTextNodeName] && (self.content)) {
		return YES;
	} else {
		return NO;
	}
}

- (NSArray *)childrenWithTagName:(NSString *)tagName
{
    NSMutableArray *matches = [NSMutableArray array];
    
    for (TFHppleElement *child in self.children) {
        if ([child.tagName isEqualToString:tagName]) {
			[matches addObject:child];
		}
    }
    
    return matches;
}

- (TFHppleElement *)firstChildWithTagName:(NSString *)tagName
{
    for (TFHppleElement *child in self.children) {
        if ([child.tagName isEqualToString:tagName]) {
			return child;
		}
    }
    
    return nil;
}

- (NSArray *)childrenWithClassName:(NSString *)className
{
    NSMutableArray *matches = [NSMutableArray array];
    
    for (TFHppleElement *child in self.children) {
        if ([[child objectForKey:@"class"] isEqualToString:className]) {
			[matches addObject:child];
		}
    }
    
    return matches;
}

- (TFHppleElement *)firstChildWithClassName:(NSString *)className
{
    for (TFHppleElement *child in self.children) {
        if ([[child objectForKey:@"class"] isEqualToString:className]) {
			return child;
		}
    }
    
    return nil;
}

- (TFHppleElement *)firstTextChild
{
    for (TFHppleElement *child in self.children) {
        if ([child isTextNode]) {
			return child;
		}
    }
    
    return [self firstChildWithTagName:TFHppleTextNodeName];
}

- (NSString *)text
{
    return self.firstTextChild.content;
}

// Returns all elements at xPath.
- (NSArray *)searchWithXPathQuery:(NSString *)xPathOrCSS
{
    NSData *data = [self.raw dataUsingEncoding:NSUTF8StringEncoding];

    NSArray *detailNodes = nil;
    if (self.isXML) {
        detailNodes = PerformXMLXPathQueryWithEncoding(data, xPathOrCSS, self.encoding);
    } else {
        detailNodes = PerformHTMLXPathQueryWithEncoding(data, xPathOrCSS, self.encoding);
    }
    
    NSMutableArray *hppleElements = [NSMutableArray array];
    for (id newNode in detailNodes) {
        [hppleElements addObject:[TFHppleElement hppleElementWithNode:newNode isXML:self.isXML withEncoding:self.encoding]];
    }
	
    return hppleElements;
}

// Custom keyed subscripting
- (id)objectForKeyedSubscript:(id)key
{
    return [self objectForKey:key];
}

@end
