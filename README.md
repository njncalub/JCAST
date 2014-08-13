# JCAST Stack

JCAST is a boilerplate with a mash of tools for rapid Alloy development. Forked from [dbankier/JAST](http://github.com/dbankier/JAST/).

Let's be opinionated then. The stack includes:

 * [Jade](http://jade-lang.com/) - the [best](http://www.yydigital.com/blog/2013/7/10/A_Case_For_Jade_With_Alloy) template engine for alloy views
 * [CoffeeScript](http://coffeescript.org/) - a little language that compiles into JavaScript
 * [Alloy](http://projects.appcelerator.com/alloy/docs/Alloy-bootstrap/index.html) - Appcelerator's own MVC Framework engine for alloy views
 * [STSS](http://github.com/RonaldTreur/STSS) - Sassy TSS, or Sassy Titanium Style Sheets
 * [TiShadow](http://tishadow.yydigital.com/) - the fastest __Open Source__ toolset for titanium development

# Prerequisites

 * Do this:
```
 [sudo] npm -dg install alloy tishadow grunt-cli stss coffee-script
```
 * [Get started](http://tishadow.yydigital.com/getting%20started) with TiShadow

# Let's Go

 * Clone the repository
 * Install the dependencies: `npm install -d`

# Commands

 * `grunt` - compiles the jade, coffee and stss files
 * `grunt [dev_android|dev_ios|dev]` - auto compile and pushes with TiShadow
 * `grunt [test_android|test_ios|test]` - run specs
 * `grunt clean` - deletes all generated files
 * `grunt [iphone6|iphone7|ipad6|ipad7|appstore|adhoc|playstore]` - commands inspired by the work of @FokkeZB on [TiNy](https://github.com/FokkeZB/tn). Project specific settings are configured at the top of the `Gruntfile.coffee`.

License: MIT
