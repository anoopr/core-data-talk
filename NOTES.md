### foursquare

* Hi!

### Anoop

* Introduction

### We are hiring!

* Find me or Susan after the talk.

### github.com/anoopr

* Slides and outline.
* Gauge audience.
* High level and fast. No code.
* Example project to follow.

### What is foursquare?

* How many people have heard of foursquare?
* How many people are checked in right now?

### One API request per screen

* API was pragmatic.

### Primitive Caching

* Serialized NSDictionary to disk.
* No uniquing.
* Atomic saves.

### APIv1

* Basic Auth is insecure. OAuth is annoying.
* Who uses XML anymore?
* Put together piecemeal.
* Naveen started making a list... a very long list.

### Kushal

* Decided to join us at foursquare.
* Handed him a MacBook and Naveen's list.
* He knocked it out of the park.

### APIv2

* Followed Facebook's lead.  OAuth2+SSL is easy and secure.
* JSON, because seriously, who uses XML anymore?
* It's gorgeous.  Kushal and I went back and forth for months.

* App starting to get more sophisticated.  Early versions were essentially about People and Places.  Now we had People, Places, Tips, and Todos.  We wanted to call out content from friends and people you follow.  Passing around NSDictionary instances became more and more annoying.  It was time to bite the bullet and create an object model.

### Core Data

* One of the things that I love about working at foursquare is that after only being there a few months, I said that I'd like to take a stab at moving the entire app to Core Data, and I got the go ahead.  After iterating on a few prototypes, we decided to port the entire App over.  This is what we learned.

### One of the first figures in the Core Data Programming Guide

* Bark is bigger than its bite.
* Really, its not so bad, and when you use it, it'll look like this.

### Simpler figure.

* Pizzaiolo Badge represents boilerplate Core Data stuff that Xcode generates for you if you select "Use Core Data for storage" when you create a new project.
* Does anyone have the Pizzaiolo badge?  (20 unique check-ins)

### Pros

* Core Data is based on Enterprise Objects Framework which is over 25 years old.
* They've already solved most of the hard problems.

### NSManagedObjectContext workflow

* NSFetchRequests, NSPredicates, NSSortDescriptor... we're not getting into that.

### Xcode Managed Object Model editor

* It makes it easy to model your objects, but it's kind of quirky/buggy.

### Things to think about

* Core Data uses single table inheritance.  We tried it so we could put common code in the base class.  There is a better way!
* Indexes speed up selects and slow down insertions.  Profile before messing with them.  Core Data automatically indexes relationships.
* Don't over model!  Our badge model is surprisingly complex.  Locked badges all have the same ID.  Unlocked badges have different IDs.  Users have badges and badgesets.  Badges can be in multiple badgesets.  Spent days trying to model it.  Then we realized that we didn't need it to be modeled.  The Tranformable attribute type allows you to just throw in arbitrary unstructure data.  In our case, we just threw in the NSDictionary from the parsed JSON response for badges.

### mogenerator

* Managed Object Generator
* Core Data can generate source files for you, but if there is one piece of advice that you follow from this entire talk, it's use mogenerator.  I mentioned that we started with a common base entity in the model so we could put common code there.  Mogenerator allows you to specify a base class.  It also creates separate "machine" files and "human" files.  Machine files contain all the generated code from the Managed Object Model and human files are empty and allow you to add behavior.  When you change the model, you just regenerate and you get new machine files without clobbering your human files.

### Ruby on Rails

* I've been working with Rails for six years, and it has changed the way I think as a software developer. ActiveRecord.

### Convention over Configuration

* Describe find_or_create behavior.
* fetchOrInsert brings find_or_create behavior to Core Data.

### Request / Insert workflow

* Describe updateWithDictionary.
* Describe what saving NSManagedObjectContext does.

### It works

* This project actually started out as a library for iPad.  It worked like a champ.
* Put it on an iPhone.  Uh oh.

### Debugging time

* Describe SQLDebug.  If there are two pieces of advice...
* Every fetchOrInsert hits the disk.  25 check-ins + 25 users + 25 venues + 75 categories = 300 separate disk requests.  Not bad on iPhone 4, but 3G and 3GS have slow flash.

### Cache priming

* Described in Implementing Find-or-Create Efficiently in Core Data Programming Guide. (Link on Github).
* Much faster, but still not responsive enough.  We are still breaking the cardinal rule of iOS development.

### Don't block the main thread

* Remember that old figure with the NSManagedObjectContext.  Let's just add a bit to it.

### Now, more like this...

* Describe figure.  We need multiple NSManagedObjectContexts because they are not thread-safe.

### Background thread

* NSPersistentStoreCoordinator is thread-safe.
* Each Context maintains its own set of objects.
* How do we notify the Context on the main thread that the background thread has made changes.

### NSManagedObjectContextDidSaveNotification

* Longest name ever.
* Different merge policies do different things.
* Great!  Now we're threaded.  UI isn't blocked and it all works swimmingly.  Of course, it wouldn't be concurrency without bugs.

### Two Kushals!

* Somebody tell me why this happened.
* When you're starting with Core Data, repeat this mantra.

### Core Data is not a Database

* While it happens to use SQLite, that's an implementation detail.
* Two requests containing the same object coming in at the same time can cause a race condition.

### NSOperationQueue

* The easiest way to solve race conditions.
* Set maxConcurrentOperationCount to 1.

### The future

* Describe slide

### Miscellaneous

* Instruments should be its own talk.
* Friends don't let friends use NSURLConnection
* Describe FullyLoaded.  It's in the example project!

### Thanks!
