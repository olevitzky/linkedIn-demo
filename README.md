# linkedIn-demo

## How to run

* I am using [Unicorn](http://unicorn.bogomips.org/) to run multiple processes, so in order to run the server install [foreman](https://github.com/ddollar/foreman) locally and run `foreman s -p 3777`
* [Sidekiq](https://github.com/mperham/sidekiq) is used for background processing to support concurrency parsing
* Make sure you have a redis server running so Sidekiq will work properly
* For populating the db with some profiles run `rake generate_profiles` after all the servers are running.

## Supported API's

```
POST api/profiles, params: username
``` 
Creates a new profile. This endpoint accepts a Linkedin username and enqueue the parsing job to run in the background. If the username already exists, returns a relevant error to the user as a json object. When the job was enqueue successfully the profile details are returned (id and uuid) so the user can check the status of the profile parsing process.

```
GET api/profiles/:id
```
Fetch the profile by the given id. The id attribute can be wither the profile sql table id or the uuid which is the LinkedIn username. If the profile was found, all its details are returned with the state of the process job.

```
GET api/profiles
```
Returns all the stored profiles added so far. The matched profiles are paginated so in order to jump to a specific page, pass a page value. (you can see the pagination details in the returned json)

```
GET api/profiles/search, params: q => {name, title, current_position, summary, score}, page
```
Search for profiles by the search query and return only the records that match those filters. Searchable attributes are:
* name - The profiles which the full_name attribute CONTAINS this field value will be returned.
* title - The profiles which the title attribute CONTAINS this field value will be returned.
* current_position - The profiles which the current_position attribute CONTAINS this field value will be returned.
* summary - The profiles which the summary attribute CONTAINS this field value will be returned.
* score - The profiles which are GREATER THAN OR EQUAL to this field value will be returned.

The matched profiles are paginated so in order to jump to a specific page, pass a page value. (you can see the pagination details in the returned json)

```
GET api/profiles/skills_search, params: skills, page
```
Searches and returns all the profiles which have one of the passed skills. The skills parameter should be a comma seperated string of fully named skills (i.e LinkedIn and not just Linked).
The matched profiles are paginated so in order to jump to a specific page, pass a page value. (you can see the pagination details in the returned json)