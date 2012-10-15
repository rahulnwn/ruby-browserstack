# Browserstack

A ruby gem for working with [BrowserStack](http://browserstack.com) through its [API](https://github.com/browserstack/api).(V2 API only)

## Installation

Add this line to your application's Gemfile:

    gem 'browserstack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install browserstack

## Example of Use

First, you're probably gonna want to require it:

``` ruby
require 'browserstack'
```

### Creating Client
Creates a new client instance.

* `settings`: A hash of settings that apply to all requests for the new client.
  * `username`: The username for the BrowserStack account.
  * `password`: The password for the BrowserStack account.

``` ruby
settings = {username: "foo", password: "foobar"}
client = Browserstack::Client.new(settings)
```

###API

####Getting available browsers
Fetches all available browsers.

``` ruby
client.get_browsers #will return a hash
```

or for a specific OS

``` ruby
client.get_browsers("mac")
```

####Getting list of supported OS

``` ruby
client.get_supported_os_list 
```

####Creating a worker
A worker is simply a new browser instance.

``` ruby
enc_url = URI.escape("http://example.com/?a=\111\\115"")
settings = {os: "win", browser: "ie7", version: "4.0", url: enc_url}
worker_id = client.create_worker(settings)
```
A worker id is returned after worker gets created.

* `settings`: A hash of settings for the worker
  * `os`: Which OS to use for the new worker.
  * `browser`/`device`: Which browser/device to use in the new worker. Which property to use depends on the OS.
  * `version`: Which version of the specified browser to use.
  * `url` : Which URL to navigate to upon creation.
  * `timeout` (optional): defaults to 300 seconds. Use 0 for "forever" (BrowserStack will kill the worker after 1,800 seconds).

####Terminating a worker
Use this method to terminate an active worker. A hash with indicating how long the worker was alive is returned.

``` ruby
data = client.terminate_worker(worker_id)
```

####Getting worker status
Determines whether the worker is in queue, running or terminated.

``` ruby
status = client.worker_status(worker_id)
```

* `status`: A string representing the current status of the worker.
  * Possible statuses: `"running"`, `"queue"`, "terminated".

####Getting all workers of a client

``` ruby
workers = client.get_workers
```
Returns an array of all workers with all their properties

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
