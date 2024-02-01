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