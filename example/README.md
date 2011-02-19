# Core Data Talk Example Project

## Setup

1. Go to <http://foursquare.com/oauth/> and register a new consumer.
2. Copy `Classes/Constants.h.sample` to `Classes/Constants.h` and update it with your Client ID, Client Secret, and Callback URL.  You can set the Callback URL to any valid URL.  For security reasons use one under your control.
3. Run the app!

## What it does...

There's not much to the functionality of this app. Its primary function is to demonstrate the design pattern described in my [Core Data Talk](https://github.com/anoopr/core-data-talk).

Everytime you hit refresh, it grabs the nearby venues from a random location within 0.5 degrees of foursquare HQ and adds it to the Core Data cache.  It uses NSFetchedResultsController to update the UITableView as these changes happen.

P.S. Do you notice the smooth scrolling on your device despite loading the category images from the network? It's FullyLoaded! Check out <http://github.com/anoopr/fully-loaded> for more details.

P.P.S. The project also uses [morsel](http://github.com/anoopr/morsel).
