# weather_aggregator
Collect weather information from multiple sources 

Additional info from Noel McNulty in request email:

Hi Matthew,

Thanks for taking the time to chat about our Software Engineer II - Perl role. I'm excited to tell you that we are
progressing your application to our technical audition phase. This is an opportunity for you to really impress us....

Read through the attached challenge document carefully and be sure to cover all areas mentioned. We want you to write
the code, in Perl.

When building out your solution, please consider the following:

     - Don't over complicate things - treat it as if it's any other task you work on

     - Avoid using tools such as AWS Lambda, it leads to problems getting it running for interviewers, and we aren't on
       serverless yet.

Once you have finished, put your solution on GitHub and send us the link. We will review as a team, and then invite you
back for a final round code review session.

Thanks,
Noel

------------------------------------------------------------------------------------------
Your Big Idea:
What if there was an application that took in weather data from up to date, trustworthy sources covering the whole
globe? You decide to create the world's first truly accurate weather information service. This is going to be your big
start-up idea. You're going to be rich, or at least internet-famous. You have your laptop, $100 (for cloud hosting, and
for GoDaddy to register a domain) and a free weekend. "That's all an entrepreneur needs these days," you think.

The Problem:
Almost as soon as you start, you see the problem. There are many different sources of weather data from all
across the planet. These sources are available via various file types, formats and technologies, so your solution
should consume data in at least two different formats.

The Solution:
You decide to architect and build a service to handle these different sources of weather data and to extract,
transform and load them into a single normalised source.

Notes:
Don't build a weather website. We only need to see the solution for the data processing part of the problem.
Weather data is large and complex. For the sake of this audition we are only interested in the following to start
with: Latitude, Longitude, UTC Time, Temperature, Wind Speed, Wind Direction, Precipitation Chance
----------

- this is a huge amount of data if we are to retrieve every available lat/long from multiple sources

Questions:
----------
- are we only interested in current weather, or are we storing weather history?

- do we want to first aggregate the data, or do we want to retrieve it live, preferably for only one location at a time?

Ideas:
------

- we can use the LWP module to retrieve specific information from weather sites that provide an API, then fiter the data
  to information we want

  - looks like it will retrieve both data and documents as needed
  - https://metacpan.org/pod/LWP

- we will need to store info on our sources, including the url, retrieval method, where the pertinent data is in the
  returned data, possibly passwords, and more.  In fact, this will most likely be a class encapsulating that data and
  retrieveal/parsing methods

- since our data is standardized, that will also be a class containing:  "Latitude, Longitude, UTC Time, Temperature,
  Wind Speed, Wind Direction, Precipitation Chance"
  - as a database entry, it will need Lat, Long, Time, and data source for a unique key

- If we want to query the data, we need a way to translate easily entered quantities like zip code or a potentially
  truncated lat/long into the full lat/long that we have.  likewise with time?  possibly get the most recent?

- retrieved files must be isolated so they are not overwritten by other retrievals, either download to an unique
  location, or uniquely named, or both.  Once processed, they can be removed or archived

- if a filename can't be known in advance or isn't known through the LWP interface, we can download to an unique
  directory and list the directory to find out, or even open the one file we find in that directory

*** found an api for sherman ct weather:
    https://www.shermanctweather.org/pwsWDtest/index.php?frame=CWOP&theme=dark&lang=en-us&units=us
    - I can retrieve a CSV
    https://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&type=.iqy
    wget 'http://weather.gladstonefamily.net/cgi-bin/wxobservations.pl?site=C0465&days=7&csv=1'")

------------------------------------------------------------------------------------------

Steps Taken:

- set up an entry class, debugged constructor, implemented a print method
  - created a test script
  - had issues with hash syntax, rookie mistake, definitely rusty

- writing code to retrieve and parse output from sherman ct weather site

* plan is to put this code and appropriate values into a config file, not sure if I want to create a base method in the
  class and augment it as weather sites are added, potentially store an anonymous subroutine in the source object

- running into an issue trying to pass the subroutine that retrieves entries into an object and assigning it to a hash element
  - passing as ref does not connect it to the subroutine, passing as the subroutine invokes it at assignment
  - may rethink the source class as a subroutine with values rather than a class with values & a subroutine

- ideally, what I want is an iterable list of subroutines that are customized for each source

- rethinking the source class:  deciding it will be more self-contained

- found another weather source, aviation METAR reports
  - will allow retrieval of every weather station at each airport in one file
  - switch the 'source' designation to the FAA/NWS designation for sherman.  Use what has already been invented
  - this has implications for how the user will retrieve value(s) for a given location.  Not likely to know weather station designations

- also realized that wget output file can be specified on the command line
------------------------------------------------------------------------------------------

I need to rethink the W_source class.  I have gone back and forth as to where the source retrieval methods should be
stored and I am back to the majority of the source information being stored in the class package itself.  Instead of
having the retrieval process stored outside the package, I think it makes more sense to store it within the package, and
provide an interface that does more of the work inside the class.

Somewhere along the way, I got the idea that I needed to pass the retrieval method into the W_source class constructor.
I think it makes more sense to have the W_source class already have that data and instead have a class object that can
iterate (or provide single source updates) over the known sources.  This gets around the problem of passing subroutines
into the constructor

FIXTHIS:  this is bound to be ambiguous, provide a clearer picture of what is meant


Get aviation METARS, csv, zipped: wget "https://aviationweather.gov/data/cache/metars.cache.csv.gz"
------------------------------------------------------------------------------------------

- method to retrieve metars information and create a W_entry for each line
- improve wget so that it writes to same file and overwrites if exists
- clean up and move sherman_get_entry and metars_get_entry

options for W_source:
	- initially thought of creating two methods:
	  - initialize() which would read in the various source_get methods, probably driven by a list
	  - execute() an update

This seems like overkill, but might be justified with a lot of sources

Now thinking of calling a class method W_source::update_all() that simply
calls the individual source_get methods consecutively

One option that might change this would be a desire to update one or a few sources

------------------------------------------------------------------------------------------

As for retrieval, I'm not clear what the user will use for location.  He could use a weatherstation/airport ID, but he
would have to know the ID.  An alternative would be to input his latitude, longitude, and a range getting back all
weather stations within a given distance





