---
layout: single
title: Users
permalink: /users/
toc: true
toc_sticky: true
toc_label: "Table of Contents"
toc_icon: "cog"
---

## What can users do?

Users can create, view, and download data from CHORDS. However a person’s access level will determine the functions available. Permissions, such as data downloader, are enhancements on a registered user, while the guest user is equivalent to not being logged in.

### Guest

Guest User Can:
- Read About page
- View self information


### Registered User

Registered User Can:
- Read About page and view data
- View Site
- View Instruments
- Can View and edit self information


### Data Downloader

You guessed it. This option lets Registered Users view and download data from instruments.

A Data Downloader can:
- Download data
- View Instruments

1. Log into chords
2. Click on **“Data”** on the left side of your screen 
3. Select the dates that you want to download data from
4. Select the instruments you want to download data from OR click **“Select All”**

5. Click **“Download GeoJSON”**


### Measurement Creator

Measurement Creator can:
- Create instruments
- Create test measurements

As a measurement creator it is recommended that you keep this account separate from other accounts that are used for data downloading or just as a registered user. Doing so prevents security issues in the future. Each Measurement user has their own API key to send measurements. 

To find your api key: 
1. Log into chords with your measurement account
2. Click on **“Users”** on the upper right corner of the screen
3. Copy the randomly generated key under API key.

<font color="red">Note: </font>You should only have ONE API key per instrument. 



## Storing Measurements

### Sending a URL from UNIX
#### Data In
It is easy to submit new data to a Portal, simply using standard HTTP URLs. The URL can be submitted directly from the address bar of your browser (but of course this would get tedious).
We will first describe the URL syntax, and follow this with examples that demonstrate how easy it is to feed your data to a CHORDS Portal, using Python, C, a browser or the command line. These are only a few of the languages that work, and you should be able to figure out a similar method for your own particular language. Almost all programming languages have functions for submitting HTTP requests.

#### URL Syntax
Sample URLs for submitting measurements to the Portal:

```
http://myportal.org/measurements/url_create?instrument_id=[INST_ID]&wdir=038&wspd=3.2&at=2015-08-20T19:50:28
http://myportal.org/measurements/url_create?instrument_id=[INST_ID]&p=981.2&email=[USER_EMAIL]&api_key=[API_KEY]
http://myportal.org/measurements/url_create?instrument_id=[INST_ID]&p=981.2&email=[USER_EMAIL]&api_key=[API_KEY]&at=2015-08-20T19:50:28&test
```

*myportal.org* is the hostname of your Portal. The fields after “?” are qualifiers, each separated by “&”.
Measurements for variables are specified by *shortname=value* pairs. You do not need to include measurements for all variables defined for the instrument, if they are not available.

<table class="table table-striped">
  <thead>
    <tr>
      <th>Qualifier</th>
      <th>Optional</th>
      <th>Meaning</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>instrument_id=id</td>
      <td>No</td>
      <td>The Portal assigned instrument identifier.</td>
    </tr>
    <tr>
      <td>at=time</td>
      <td>Yes</td>
      <td>Specify a timestamp to be applied to the measurements. If <em>at</em> is not specified,
      the measurement will be stamped with the time that it was received by the Portal (often
      quite adequate). The time format is <a href="https://en.wikipedia.org/wiki/ISO_8601">ISO8061</a>.</td>
    </tr>
    <tr>
      <td>email=[USER_EMAIL]</td>
      <td>Yes</td>
      <td>If the Portal has been configured to require a security key for incoming measurements, the user email, <em>email</em> qualifier is needed.</td>
    </tr>
    <tr>
      <td>api_key=[API_KEY]</td>
      <td>Yes</td>
      <td>If the Portal has been configured to require a security key for incoming measurements, it
      is specified with the <em>api_key</em> qualifier. Keys are case sensitive and specific for a given user with the measurements permission enabled.</td>
    </tr>
    <tr>
      <td>test</td>
      <td>Yes</td>
      <td>Add the <em>test</em> qualifier to signify that the measurements are to be marked as test
      values. Test measurements may be easily deleted using the Portal interface.</td>
    </tr>
  </tbody>
</table>

#### Programming Examples

<div id="tabs">
  <ul>
    <li><a href="#tabs-Browser">Browser and Sh</a></li> <!-- names on the tabs -->
    <li><a href="#tabs-Python" >Python</a></li>
    <li><a href="#tabs-C">C</a></li>
  </ul>
  <div id="tabs-Browser"> <!-- content under tab -->
  <div id="browser" class="tab-pane active">
  Data can be submitted to a portal just by typing the URL into the address bar of a browser. It's unlikely that you would use this method for any serious data collection!
  <!-- Add picture here -->
  {% highlight sh %}
  wget http://chords.dyndns.org/measurements/url_create?instrument_id=25&wdir=121&wspd=21.4&wmax=25.3&tdry=14.3&rh=55&pres=985.3&raintot=0&batv=12.4&at=2015-08-20T19:50:28&email=[USER_EMAIL]&api_key=[API_KEY]

  curl http://chords.dyndns.org/measurements/url_create?instrument_id=25&wdir=121&wspd=21.4&wmax=25.3&tdry=14.3&rh=55&pres=985.3&raintot=0&batv=12.4&at=2015-08-20T19:50:28&email=[USER_EMAIL]&api_key=[API_KEY]
  {% endhighlight %}

  The <i>wget</i> and <i>curl</i> commands, available in Linux and OSX, can accomplish the same thing from a console.

  </div>
  </div>

  <div id="tabs-Python"> <!-- content under tab -->
  <div id="python" class="tab-pane active">
  {% highlight python %}
  #!/usr/bin/python

  #Put a collection of measurements into the portal
  import requests
  url = 'http://my-chords-portal.com/measurements/url_create?instrument_id=3&t=27.1&rh=55&p=983.1&ws=4.1&wd=213.5&email=[USER_EMAIL]&api_key=[API_KEY]'
  response = requests.get(url=url)
  print response
  ...
  <Response [200]>
  {% endhighlight %}
  </div>
  </div>

  <div id="tabs-C"> <!-- content under tab -->
  <div id="c" class="tab-pane active">

  This example uses the <a href="https://curl.haxx.se/libcurl/c/libcurl.html">libCurl</a> library in a C program to send a measurement URL to a portal.

  {% highlight c %}
  #include <stdio.h>
  #include <curl/curl.h>

  int main(void)
  {
    CURL *curl;
    CURLcode res;

    curl = curl_easy_init();
    if(curl) {
      char* url = "http://chords.dyndns.org/measurements/url_create?instrument_id=25&wdir=121&wspd=21.4&wmax=25.3&tdry=14.3&rh=55&pres=985.3&raintot=0&batv=12.4&at=2015-08-20T19:50:28&email=[USER_EMAIL]&api_key=[API_KEY]";
      curl_easy_setopt(curl, CURLOPT_URL, url);
      /* example.com is redirected, so we tell libcurl to follow redirection */
      curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

      /* Perform the request, res will get the return code */
      res = curl_easy_perform(curl);
      /* Check for errors */
      if(res != CURLE_OK)
        fprintf(stderr, "curl_easy_perform() failed: %s\n",
                curl_easy_strerror(res));

      /* always cleanup */
      curl_easy_cleanup(curl);
    }
    return 0;
  }
  {% endhighlight %}
  </div>
  </div>
</div>
<script>
$("#tabs").tabs();
</script>







### Particle
How to create a JSON string using Particle

1. In the beginning of your program add the line: ``#define ARDUINOJSON_ENABLE_ARDUINO_STRING 1``
2. Add the library ArduinoJSON ``#include <ArduinoJson.h>``
3. In Loop initialize the JSON, Add variables to the JSON, Publish the JSON as a string

<font color="red">Note:</font> the items that say ``leaf.<something>`` are pulling data from sensors.

```java
DynamicJsonBuffer jBuffer; 
//create a new JSON object to send the sensor data
JsonObject& jsondata = jBuffer.createObject();
 
//Pull Sensor data to variables
float temp = leaf.bme_temp();
float rh_humid = leaf.bme_rh();
float pressure = leaf.bme_p();
 
//JSON string creation
jsondata["bme_temp"] = temp;
jsondata["bme_rh"] = rh_humid;
jsondata["bme_pressure"] = pressure;
 
// Created a new variable named data that is of type string which is needed for particle publish
String data;
jsondata.printTo(data);
Particle.publish("Data",data);
```

For this next step make sure you have the following from your CHORDS portal

**instrument id number**  
**API Key** (Under users)  
**URL** (selecting “Data URLs” and then everything up to the “?”)  

- Log into your [Particle Cloud Console](https://login.particle.io/login?redirect=https://console.particle.io/devices)
- On the left hand side select **“Integrations”** then **“New Integration”**
- Click **"Webhook"**
<img  class="img-responsive" src="{{ site.baseurl }}/assets/images/Webhook.png">
- For **event name** type in the name of the Particle Publish event Title (eg. if your code has Particle.publish(“Full Data”, datum); then the event name would be “Data”)
- For the **URL** paste in the URL from “DataURLs” found in CHORDS up to and including the “?”
- For **Request Type** select **"GET"**
- For **Device**, select the appropriate device or leave it as any depending on the project
- Click **"Advanced Settings"**
- Under **"Form Fields"** select **"Custom"**
- In the first two fields type **“instrument_id”** and the number of your instrument id from CHORDS
- Click **"Add Row"**
- In the rows first field type the **“short_name”** from your CHORDS and in the second field enter the **“JSON Key Name”** within a set of two braces (eg. {{short_name}} )  
Chords Short Name
<img  class="img-responsive" src="{{ site.baseurl }}/assets/images/ChordsVariables.png">
JSON Key Name
<img  class="img-responsive" src="{{ site.baseurl }}/assets/images/JSONKeyName.png">
<font color="red">Note:</font>short_name from CHORDS and the JSON key name should MATCH. 
- Continue to add rows for all of your variables
- Click **“Create Webhook”**
<p class="notice--primary">Do not Particle.publish data faster than 1 per second or Particle will complain and or limit your ability to stream data (you can insert a “delay(1000);” in your code after a Particle.publish to prevent this issue)</p>

----------------------------------------------------------------------------------------------------------------------------------------------------

## Retrieving Data 

### Download Data

To download data first go to the Data tab in your CHORDS portal. From here you can download data 4 different ways.

1. You can download data within a determined date range.
2. You can download data by selecting specific instruments and then clicking "Download GeoJSON"
3. You can download all of your data by clicking "Select All" and then clicking "Download GeoJSON"
4. You can select "Data URLs" then select the generated url. Combine this with custom code to continue to pull specific data types.

### Grafana
[Grafana](https://grafana.com) is an open-source visualization system that allows you to create powerful data dashboards, right from the browser. The dashboards are very responsive because they fetch data directly from the CHORDS database. The extensive [Grafana documentation](http://docs.grafana.org) explains how to unleash the full capability of the system.

However, the following tutorial explains quickly how to configure Grafana to interact with CHORDS, and how to create a simple dashboard.

**Note: You should have the portal configured with at least one site/instrument/variable before trying to create a dashboard. If there is no data in the portal, you can create some test data using the simulation function.**

Extra credit: once you have been able to make a simple Grafana graph, see this [tutorial](http://docs.grafana.org/features/datasources/influxdb/) for indepth instructions on database access and calculations.

1. **Open Grafana**
  The visualization link will open a new browser window which provides access to the Grafana time-series visualization system.
<img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_011.png">
2. **Login**
  - Sign in to Grafana
<img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_010.png">
3. **Creating a datasource**
  - Add a data source:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_030.png">
  - Configure the data source:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_040.png">
  - When configured correctly, success will be indicated:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_041.png">
  - If something is not configured correctly, you may see a message: **"Unknown error":**
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_042.png">
    - Make changes, and mash **Save & Test** again.

4. **Add a dashboard**
  - Select New dashboard:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_050.png">
  - A new dashboard is created, with an empty panel. Add a graph by pressing Graph:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_051.png">
  - Click in the bar at the top of the graph, to pop up a menu:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_060.png">
  - And select Edit:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_070.png">
  - Configure the panel: 
    Use the General tab to set a title:
    <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_110.png">
    Use the Display tab to change the appearance:
    <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_100.png">
    The variable identifires are obtained from the CHORDS Instruments page: <!--Need to grab a picture from chords for this-->
    <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_120.png">
    Use the Metrics tab to configure the database access. Close when you see plotted data:
    <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_095.png">

5. **Change the admin password**
  - Finally, be sure to change (and remember) the admin password for grafana. This is accessed through Admin->Profile:
  <img  class="img-responsive" src="{{ site.baseurl }}/assets/images/grafsetup_020.png">

