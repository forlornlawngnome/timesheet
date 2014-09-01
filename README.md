# Licensing

This work is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-nc-sa/4.0/).


# Installing/Running

#### Prerequisites 
* PostgreSQL
* Ruby on Rails 3.2.13

#### Heroku Setup
I suggest using [heroku](https://www.heroku.com/) to host it. It's free (as long as you use no more than 1 thread a month), it allows access from any computer, and has postgres and RoR installed by default.

To install on heroku:
<ol>
	<li>
		Pull from git run this command in the command line:
	
<blockquote> $ git clone <repository url> <br />
Note: The repository url can be found on the side of the github page </blockquote>
</li>
	<li>Modify code/[settings](#changing-settings) to fit your needs </li>
	<li>[Push to Heroku](https://devcenter.heroku.com/articles/getting-started-with-ruby#deploy-the-app)</li>
</ol>
#### Install elsewhere
I highly suggest that you install it someplace with remote access. That way time requirements can be checked from anywhere.

<ol>
	<li>Install Ruby on Rails (I suggest http://rvm.io/)</li>
	<li>Install PostgreSQL (http://www.postgresql.org/)</li>
	<li>Pull down the code and set it up</li>
```
$ git clone <repository url>
Note: The repository url can be found on the side of the github page
$ cd timesheet
$ bundle install
```

	<li>Modify code/[settings](#changing-settings) to fit your needs (you should probably modify config/database.yml to password protect your database)
	<li>Start the server</li>
		
```
$ rails server -p <port> -e production
Note: This app uses the default rails server, you probably want to switch to thin, passenger or unicorn for better options and stability. Heroku has this by default
Note: By default rails uses port 3000, that would make the url on a local machine localhost:3000 by default websites normally run on 80 (http) or 443 (https). Some machines don't allow servers open on these ports and Apache or custom routing tables can be used.
```

</ol>

# Changing settings

There are some settings which can be changed to adapt this for your team.
These can be found in app/helpers/application_helper.rb

### Timezone
> <dl>
> 	<dt>Description</dt>
> 	<dd>
> 		The time zone associated with the times. It will determine what times show up, when the end of the day is, etc.
> 	</dd>
> 	<dt>Method</dt>
> 	<dd>
> 		self.TimeZone
> 	</dd>
> 	<dt>Default</dt>
> 	<dd>
> 		Eastern Standard Time
> 	</dd>
> 	<dt>Modification</dt>
> 	<dd>
> 		Change the string to one of the approved rails timezones. 
>		<ul>
> 		 	<li>To get the timezones, you can run the command rake time:zones:all (computer must have RoR installed)</li>
>   	  	<li> More info on getting timezone list: http://codedecoder.wordpress.com/2013/09/09/timezone-in-rails/</li>
>   	  	<li> Timezones are also listed below</li>
>		</ul>
> 	</dd>
> </dl>

### Start of Year
> <dl>
> 	<dt>Description</dt>
> 	<dd>
> 		This is when the 'year' begins. Views of weeks start with the first day in the month
> 	</dd>
> 	<dt>Method</dt>
> 	<dd>
> 		self.getStartMonth
> 	</dd>
> 	<dt>Default</dt>
> 	<dd>
> 		1st of July
> 	</dd>
> 	<dt>Modification</dt>
> 	<dd>
> 		Change the 7 (July) to the integer corresponding to the month you want to begin
> 	</dd>
> </dl>

		
### Last Out
> <dl>
> 	<dt>Description</dt>
> 	<dd>
> 		The last possible time to sign out for the day. If a record isn't signed out by then, only 1 minute is credited for the day.
> 	</dd>
> 	<dt>Method</dt>
> 	<dd>
> 		self.today
> 	</dd>
> 	<dt>Default</dt>
> 	<dd>
> 		1 am
> 	</dd>
> 	<dt>Modification</dt>
> 	<dd>
> 		Change the 1 in the if statement to correspond with the number of hours after midnight to cut off
> 	</dd>
> </dl>
	
### Build Season Hours Required
> <dl>
> 	<dt>Description</dt>
> 	<dd>
> 		The minimum number of hours required from a student during build season. This is used in the student view. Will show true/false based >on meeting the different criteria
> 	</dd>
> 	<dt>Method</dt>
> 	<dd>
> 		hoursBuildSeason(hours)
> 	</dd>
> 	<dt>Default</dt>
> 	<dd>
> 		6 hours
> 	</dd>
> 	<dt>Modification</dt>
> 	<dd>
> 		Change the 6 to the number of hours required
> 	</dd>
> </dl>
	
### Build Season Meetings Required
> <dl>
> 	<dt>Description</dt>
> 	<dd>
> 		The minimum number of meetings required from a student during build season. This is used in the student view. Will show true/false >based on meeting the different criteria
> 	</dd>
> 	<dt>Method</dt>
> 	<dd>
> 		meetingsBuildSeason(hours)
> 	</dd>
> 	<dt>Default</dt>
> 	<dd>
> 		2 Meeting
> 	</dd>
> 	<dt>Modification</dt>
> 	<dd>
> 		Change the 2 to the number of meetings required
> 	</dd>
> </dl>

### Pre Season Meetings Required
> <dl>
> 	<dt>Description</dt>
> 	<dd>
> 		The minimum number of meetings required from a student during build season. This is used in the student view. Will show true/false >based on meeting the different criteria
> 	</dd>
> 	<dt>Method</dt>
> 	<dd>
> 		meetingsBuildSeason(hours)
> 	</dd>
> 	<dt>Default</dt>
> 	<dd>
> 		1 Meeting
> 	</dd>
> 	<dt>Modification</dt>
> 	<dd>
> 		Change the 2 to the number of meetings required
> 	</dd>
> </dl>


# Timezones
* UTC -11:00 
  * American Samoa
  * International Date Line West
  * Midway Island

* UTC -10:00
  * Hawaii

* UTC -09:00
  * Alaska

* UTC -08:00
  * Pacific Time (US & Canada)
  * Tijuana

* UTC -07:00
  * Arizona
  * Chihuahua
  * Mazatlan
  * Mountain Time (US & Canada)

* UTC -06:00
  * Central America
  * Central Time (US & Canada)
  * Guadalajara
  * Mexico City
  * Monterrey
  * Saskatchewan

* UTC -05:00
  * Bogota
  * Eastern Time (US & Canada)
  * Indiana (East)
  * Lima
  * Quito

* UTC -04:30
  * Caracas

* UTC -04:00
  * Atlantic Time (Canada)
  * Georgetown
  * La Paz
  * Santiago

* UTC -03:30
  * Newfoundland

* UTC -03:00
  * Brasilia
  * Buenos Aires
  * Greenland

* UTC -02:00
  * Mid-Atlantic

* UTC -01:00
  * Azores
  * Cape Verde Is.

* UTC +00:00
  * Casablanca
  * Dublin
  * Edinburgh
  * Lisbon
  * London
  * Monrovia
  * UTC

* UTC +01:00
  * Amsterdam
  * Belgrade
  * Berlin
  * Bern
  * Bratislava
  * Brussels
  * Budapest
  * Copenhagen
  * Ljubljana
  * Madrid
  * Paris
  * Prague
  * Rome
  * Sarajevo
  * Skopje
  * Stockholm
  * Vienna
  * Warsaw
  * West Central Africa
  * Zagreb

* UTC +02:00
  * Athens
  * Bucharest
  * Cairo
  * Harare
  * Helsinki
  * Istanbul
  * Jerusalem
  * Kyiv
  * Pretoria
  * Riga
  * Sofia
  * Tallinn
  * Vilnius

* UTC +03:00
  * Baghdad
  * Kuwait
  * Minsk
  * Nairobi
  * Riyadh

* UTC +03:30
  * Tehran

* UTC +04:00
  * Abu Dhabi
  * Baku
  * Moscow
  * Muscat
  * St. Petersburg
  * Tbilisi
  * Volgograd
  * Yerevan

* UTC +04:30
  * Kabul

* UTC +05:00
  * Islamabad
  * Karachi
  * Tashkent

* UTC +05:30
  * Chennai
  * Kolkata
  * Mumbai
  * New Delhi
  * Sri Jayawardenepura

* UTC +05:45
  * Kathmandu

* UTC +06:00
  * Almaty
  * Astana
  * Dhaka
  * Ekaterinburg

* UTC +06:30
  * Rangoon

* UTC +07:00
  * Bangkok
  * Hanoi
  * Jakarta
  * Novosibirsk

* UTC +08:00
  * Beijing
  * Chongqing
  * Hong Kong
  * Krasnoyarsk
  * Kuala Lumpur
  * Perth
  * Singapore
  * Taipei
  * Ulaan Bataar
  * Urumqi

* UTC +09:00
  * Irkutsk
  * Osaka
  * Sapporo
  * Seoul
  * Tokyo

* UTC +09:30
  * Adelaide
  * Darwin

* UTC +10:00
  * Brisbane
  * Canberra
  * Guam
  * Hobart
  * Melbourne
  * Port Moresby
  * Sydney
  * Yakutsk

* UTC +11:00
  * New Caledonia
  * Vladivostok

* UTC +12:00
  * Auckland
  * Fiji
  * Kamchatka
  * Magadan
  * Marshall Is.
  * Solomon Is.
  * Wellington

* UTC +13:00
  * Nuku'alofa
  * Samoa
  * Tokelau Is.

