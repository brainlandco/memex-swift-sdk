# Memex Swift SDK

[![CI Status](http://img.shields.io/travis/adamzdara/MemexSwiftSDK.svg?style=flat)](https://travis-ci.org/adamzdara/MemexSwiftSDK)
[![Version](https://img.shields.io/cocoapods/v/MemexSwiftSDK.svg?style=flat)](http://cocoapods.org/pods/MemexSwiftSDK)
[![License](https://img.shields.io/cocoapods/l/MemexSwiftSDK.svg?style=flat)](http://cocoapods.org/pods/MemexSwiftSDK)
[![Platform](https://img.shields.io/cocoapods/p/MemexSwiftSDK.svg?style=flat)](http://cocoapods.org/pods/MemexSwiftSDK)

## What is Memex?

Memex is lightweight personal knowladge base with automatic content management. It means that it helps organise every piece of knowledge (notes, urls, sketches, comments, etc.). These pieces (spaces) are interconnected using memory links which helps to navigate and associate it into more compact knowledge. It is just like web but more lightweight and only personal. 

### Space
Core concept of Memex is space which is bundle/collection/folder of small pieces of knowledge. It can be piece of text (text space) note or large collection of links to other collections (collection space).

There is a few standard space types in two core categories:

1. Collection-oriented - defined/represented by its caption
	* Collection - abstract set of links to other spaces
2. Atomic (shortly atoms) - defined/represented by caption and linked media
	* WebPage - decorated URL to any webpage
	* Text - small textual piece of information/note or anything that can be written
	* Image - visual piece of knowledge

Space has wollowing structure:

```swift
class Space{
  var MUID: String?
  var createdAt: Date?
  var updatedAt: Date?
  var state: ObjectState?
  var caption: String?
  var color: Color?
  var typeIdentifier: String?
  var unread: Bool?
  var ownerID: Int?
  var representations: [Media]?
}
```

### Link

Another core principle of memex is link which is nothing more than connection between two spaces. So if there exists association between two things/ideas/spaces in users brain there should also exist oriented link in memex.

```swift
class Link {
  var MUID: String?
  var createdAt: Date?
  var updatedAt: Date?
  var state: ObjectState?
  var ownerID: Int?
  var order: Int?
  var originSpaceMUID: String?
  var targetSpaceMUID: String? 
}
```

### Media

Piece of data that can be users avatar or image/textual representation of space.

```swift
class Media {
  var MUID: String?
  var createdAt: Date?
  var updatedAt: Date?
  var state: ObjectState?
  var metadata: [String: Any]?
  var dataState: DataState?
  var kind: String?
  var embededData: Data?
  var dataDownloadURL: URL?
  var dataUploadURL: URL?
  var ownerID: Int?
  var representedSpaceMUID: String?
}
```

## Smart Fetaures

Today memex supports two smart features that will help user to automatically manage his content.

#### Auto-Categorization (Autodump)

First one is called autodump and will automatically link new space with most fitting already existing space. Eg. If user drops webpage url and there already exists similar collection of spaces then Memex will try to automatically create link from this collection to newly created space. See Examples section.

#### Auto-Captioning

Are you creating collection of spaces but dont know how to name it?Another smart feature that is offered by Memex is automatic captioning/summarization of space. Just provide set of space MUIDs and we will tell you what is the best name for it.


## Setup

MemexSwiftSDK is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:


### 1. Create app and get your app token

Go to [Memex Dev Center](https://memex.co/apps/dev) and create your app. You dont need to wait for approval and continue to step 2.  


### 2. Add pod to podfile

Go to your podfile and add following line.

```ruby
pod "MemexSwiftSDK"
```

### 3. Import module

Import memex sdk into every Swift file where you want to use it.

```swift
import MemexSwiftSDK
```

### 4. Configure SDK with app token


In your AppDelegate.swift or any place where you bootstrap your libraries place this line.

```swift
let memex = Memex(appToken: "<YOUR APP TOKEN>")
memex.prepare {
  // memex object is ready for usage
}
```

## Examples

### Authentication

First supported user authentication method is using clients credentials (email & password).

```swift
let credentials = new Credentials("email@host.com", "secretPASSWORD")
memex.loginUserWithUserCredentials(credentials) { error in
  guard error == nil else {
    // show login failure dialog
  }
  // let user into app
}
```

```swift
// it can be generated UUID or retrieved from iCloud
let onboardingToken = "xxxx" 
memex.loginUserWithOnboardingToken(onboardingToken) { error in
  guard error == nil else {
    // show login failure dialog
  }
  // let user into app
}

```

### Get origin/space

If you want get users origin space or any other space use its MUID (memex unique identifier).

```swift
memex.getSpace("origin") { space, error in
  guard error == nil else {
    // show error message
  }
  // show space to user and load its links using getSpaceLinks
}
```

### Get links

```swift
memex.getSpaceLinks("origin") { links, error in
  guard error == nil else {
    // show error message
  }
  // show space links
}
```

### Create space

If you want to create new space in users memex you can use following code.

```swift
let space = new Space();
space.caption = "iOS 11 Stuff"
space.typeIdentifier = "com.memex.media.collection"
let autodump = true;
memex.createSpace(space, .async, autodump, completion);
```

## Documentation

Each function of SDK is documented using Swift Documentation and is accessible using Alt+Click in XCode. See generated [documentation](http://memex.co/apps/dev/doc/swift).

## Other Platform APIs

* [REST API](https://github.com/memexapp/memex-rest-api-doc)  
* [JS SDK](https://github.com/memexapp/memex-js-sdk)  
* [Go SDK](https://github.com/memexapp/memex-go-sdk)  

## Contact Us

If you need any other help please contact us at [hello@memex.co](mailto:hello@memex.co)  
