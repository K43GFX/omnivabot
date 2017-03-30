# Omnivabot

Omnivabot is a lightweight gem which allows to track parcels without actually going to tracking website. As of now, the system only supports parcels that arrive to or deport from Estonia. The gem scrapes Omniva's page https://omniva.ee for tracking information. Also, it is capable of sending desktop notifications to desktop using notify-send (tested only in Ubuntu 16.04)

## Installation

To start off, clone this repo

    $ git clone git@github.com:K43GFX/omnivabot.git

Go into omnivabot's directory, then execute:

    $ bundle install
    
in order to install all required Ruby dependencies.

Now you need a ghost browser in a binary form. I have tested this gem with Chrome driver,
you can get it here: https://sites.google.com/a/chromium.org/chromedriver/downloads

When the binary is downloaded, please move it to your PATH. In Linux, 

    $ echo $PATH

shows all the directories where you can put the chromedriver. Usually `/usr/bin/` works fine.

## Usage

This gem comes with an executable which is used to put the application to work. 
To add your tracking codes to tracking list, please open `bin/omnivabot` executable and add your tracking lines as shown in the example:

```
tracker.discover('XXXXXXXXXXX') #this is your tracking code
tracker.discover('YYYYYYYYYYY') #you can add multiple instances!
```

Now you can actually put the program to work. Execute while being on the gem's directory:

`bundle exec bin/omnivabot`


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/K43GFX/omnivabot.

