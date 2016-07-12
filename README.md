# linkedIn-demo

## How to run

* I am using [Unicorn](http://unicorn.bogomips.org/) to run multiple processes so inorder to run the server install [foreman](https://github.com/ddollar/foreman) locally and run `foreman s -p 3777`
* [Sidekiq](https://github.com/mperham/sidekiq) is used for background processing to support concurrency parsing
* Make sure you a redis server running so Sidekiq will work properly

## Supported API's

* Create a new profile
```
POST api/profiles

Mandatory params: username
```

