# Hpple

Hpple: A nice Objective-C wrapper on the XPathQuery library for parsing HTML.

## CREDITS

This is a fork of the original [Hpple](http://github.com/topfunky/hpple). I just cleaned up the code a bit, updated the tests, and added a podspec.

Hpple was created by Geoffrey Grosenbach, [Topfunky Corporation](http://topfunky.com) and [PeepCode Screencasts](http://peepcode.com), inspired by why the lucky stiff's [Hpricot](http://github.com/why/hpricot/tree/master), based on Matt Gallagher's [XPathQuery](http://www.cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html) code.

[Contributors](https://github.com/topfunky/hpple/graphs/contributors)

## FEATURES

- Easy searching by XPath (CSS selectors are planned)
- Parses HTML (XML coming soon)
 Easy access to tag content, name, and attributes.

## INSTALLATION

### CocoaPods

`pod 'Hpple', :git => 'http://github.com/zachwaugh/hpple.git'`

### Manual

- Open your XCode project and the Hpple project.
- Drag the "lib" directory to your project.
- Add the libxml2.2.dylib framework to your project and search paths as described at [Cocoa with Love](http://cocoawithlove.com/2008/10/using-libxml2-for-parsing-and-xpath.html)

More documentation and short screencast coming soon...

## USAGE

See TFHppleHTMLTest.m in the Hpple project for samples.

```objc
#import "TFHpple.h"

NSData  * data      = [NSData dataWithContentsOfFile:@"index.html"];

TFHpple * doc       = [[TFHpple alloc] initWithHTMLData:data];
NSArray * elements  = [doc search:@"//a[@class='sponsor']"];

TFHppleElement * element = [elements objectAtIndex:0];
[e text];                       // The text inside the HTML element (the content of the first text node)
[e tagName];                    // "a"
[e attributes];                 // NSDictionary of href, class, id, etc.
[e objectForKey:@"href"];       // Easy access to single attribute
[e firstChildWithTagName:@"b"]; // The first "b" child node
```

## TODO

* Internal error catching and messages
* CSS3 selectors in addition to XPath
