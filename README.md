[![Build Status](https://travis-ci.org/danielpclark/clock_window.svg?branch=master)](https://travis-ci.org/danielpclark/clock_window)
[![Gem Version](https://badge.fury.io/rb/clock_window.svg)](https://badge.fury.io/rb/clock_window)
[![Code Triagers Badge](http://www.codetriage.com/danielpclark/clock_window/badges/users.svg)](http://www.codetriage.com/danielpclark/clock_window)

# Clock Window
[![OS Support](https://github.com/danielpclark/clock_window/blob/master/assets/mac-lin.png)]()

**Mac** & **Linux** compatible.

A minimalist script to keep track of how long each window is active.
Measured in quarter minutes.  Hash builds until you kill the script with CTRL-C
at which point it writes out the log file.  This script <del>adds no extra CPU load</del>
will not raise the CPUs temperature indicating minimal CPU usage.

The output will look quite nice in any text editor aligned by the colon separator.

Output looks like:
```
{
  "*---------- WINDOW NAME ----------*"                           : "minutes",
  "Pandora Internet Radio - Listen to Free Music You'll Love - C" : 0.5,
  "MetaRuby - Ruby Forum - Chromium"                              : 0.25,
  "New Tab - Chromium"                                            : 0.5,
  "Ruby Weekly Issue 296: May 5, 2016 - Chromium"                 : 0.5 
}
```

# Installation

```
gem install clock_window
```

# Usage

The `clock_window` script now accepts command line parameters.

```
usage: clock_window [options]

    -c, --clean   Use all known name filters
    -o, --output  File/directory output in strftime
    -e, --eager   Use strftime of time at start of script

    --version     Print the version
    -h, --help    This help menu
```

And to save the file in a `year-month/day_of_year.json` format you can execute the script with.

```
clock_window -ceo "%Y-%m/%j.json"
```

For more customizable date formats see the [documentation for strftime](http://apidock.com/ruby/DateTime/strftime).
Default file output name is `timelog.json`.

# Contributing

Feel free to contribute!  We're looking for additional OS support by people who use different operating systems.

## The MIT License (MIT)
Copyright (c) 2016 Daniel P. Clark

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
