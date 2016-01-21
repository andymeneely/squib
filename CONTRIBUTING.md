# Contributing to Squib

Please use GitHub issues for bugs and feature requests.

## Need Help?

There are lots of people using Squib already. If you've gone through the [samples](https://github.com/andymeneely/squib/tree/master/samples) and still have questions, here are some other places to get help.

* [StackOverflow](http://stackoverflow.com/questions/ask?tags=ruby squib) with the tag "ruby" and "squib" will get you answers quickly and a great way to document questions for future Squibbers.
* Our [thread on BoardGameGeek](http://boardgamegeek.com/thread/1293453) is quite active and informal (if a bit unstructured).

If you email me directly I'll probably ask you to post your question publicly so we can document answers for future Googling Squibbers.

## Pull Requests

If you are contributing a new feature:
* Keep your change small and atomic. Do significant refactoring in a separate pull request.
* Please write a sample demonstrating your new feature. Place it in the samples/ directory
* While your pull request is open, please keep it up to date with the `dev` branch so it can be easily integrated
* We (sort of) follow [these Ruby style guidelines](https://github.com/bbatsov/ruby-style-guide)

## Get Involved in the Community

Let's help each other out! Even if you're relatively new, there's probably some question out there that you can help answer. Here's how to help:

* Subscribe to our thread on BoardGameGeek (see above for link)
* Subscribe to alerts from Stackoverflow for the tags "squib" and "ruby"
* Post snippets of your code using GitHub gists
* Write a how-to tutorial and post it on [our wiki](https://github.com/andymeneely/squib/wiki)

## Testing Pre-Builds

Testers needed!! If you want to test new features as I develop them, or make sure I didn't break your code, you can always point your Gemfile to the repository and follow what I'm doing there. Your Gemfile specification looks like this:

```ruby
gem 'squib', git: 'git://github.com/andymeneely/squib', branch: 'dev'
```
* The `dev` branch is where I am working on features in-process. I have not done much regression testing at this point, but would love testing feedback nonetheless.
* The `master` branch is where I consider features and bug that are done and tested, but not released yet.
* Use `bundle exec` to execute your code (e.g. `bundle exec rake` or `bundle exec ruby deck.rb`). See [Bundler](http://bundler.io) for more info.
