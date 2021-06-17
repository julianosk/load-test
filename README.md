# Load / Integration Tests

These tests simulate actual end user usage of the application. They are used to validate the overall functionality and can also be used to put simulated load on the system. The tests are written using [locust.io](http://locust.io)

### Parameters
* `[host]` - The hostname (and port if applicable) where the application is exposed. (Required)
* `[number of users]` - The nuber of concurrent end users to simulate. (Optional: Default is 2)
* `[total time]` - The total time which locust will be running for. Default: 5s.

## Requirements

* locust `pip install locust`

## Running locally

`./runLocust.sh -h [host] -u [number of users] -t [total time]`

## Running in Docker Container
* Build `docker build -t load-test .`
* Run `docker run load-test -h [host] -u [number of users] -t [total time]`
