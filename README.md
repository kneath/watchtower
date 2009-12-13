# GitHub Watchtower

An example application built in Sinatra, Mustache, MongoDB.  I created this to better learn this particular tech stack.  It monitors twitter and hacker news (for now) for mentions of GitHub and displays them for you.  Much of the setup and code structure came from [defunkt](http://github.com/defunkt) (on a closed source app).

![Example Screenshot](http://share.kyleneath.com/captures/GitHub_Watchtower-20091213-144412.jpg)

This application doesn't have a lot of immediate usefulness that services like BackType already offer, except that you can host this yourself.

## Dependencies

* MongoDB
* Mongo.rb
* Sinatra
* Mustache
* Shotgun

## Starting the app

`rake start` and then browse to <http://localhost:9393>

## TODO

* Add in a test suite (what? blasphemy!)
* Have an idea of read/unread items
* Move polling to the server, do not depend on browser being open
* Monitor Hacker News comments in addition to stories
* Ignore / Save (favorite?) events