# linkedIn-demo

## How to run

* I am using [Unicorn](http://unicorn.bogomips.org/) to run multiple processes, so inorder to run the server install [foreman](https://github.com/ddollar/foreman) locally and run `foreman s -p 3777`
* [Sidekiq](https://github.com/mperham/sidekiq) is used for background processing to support concurrency parsing
* Make sure you have a redis server running so Sidekiq will work properly

## Supported API's

```
POST api/profiles, params: username
``` 
Creates a new profile. This endpoint accepts a Linkedin username and enqueue the parsing job to run in the background. If the username already exists, returns a relevant error to the user as a json object. When the job was enqueue successfully the profile details are returned (id and uuid) so the user can check the status of profile parsing process.

