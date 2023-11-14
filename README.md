# fio-stuff

Some tools and scripts related to Jens Axboe's Flexible IO (fio)
tester.

## Copyright

Copyright 2015 PMC-Sierra, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you
may not use this file except in compliance with the License. You may
obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0 Unless required by
applicable law or agreed to in writing, software distributed under the
License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for
the specific language governing permissions and limitations under the
License.

## Setup

Make sure you have fio on your path somewhere. Most distros have
binaries for it or you can grab the source and install it yourself
from https://github.com/axboe/fio.

To run the post-processing scripts you will need python and gnuplot. I
have tested using fio 2.2.6, python 2.6.6 and gnuplot 4.2 but the code
is generic enought that other versions should work. Send pull requests
if you see issues.

## Directory Structure

### fio-scripts

Contains some useful FIO scripts that I use for different
purposes. Some of the more variable fields in these files are
environment variables which can either be set by running the
defaults.sh script or altered to suit your needs. Also for each .fio
script there is an (optional) .sh script that calls the .fio in a
certain loop.

### pp-scripts

A range of post-processing scripts that either parse fio output or
things like the latency files to generate interesting datasets for
plotting.

### tools

A variety of tools we use to assist in one or more of the tests.

## Quick Start (latency.sh)

  1. Ensure fio, python and gnuplot are installed and on your path.
  1. cd into top-level folder (fio-stuff by default).
  1. Check that the defaults in ./latency.sh are to your liking and
     match your system. 
  1. Run:
     ```sudo ./latency.sh -f <filename> -i <iodepth> -r <rwmixread> -s <size>```
     [NB you may not need sudo depending on permissions]. Note that
     device needs to be a block device or regular file with rw
     permissions. Use -r 0 for write latency plots, the default is for
     read latency plots (-r 100).
  1. This should create two file called ${FILENAME}_read_lat.1.log and
     ${FILENAME}_write_lat.2.log and two file called latency.time.png and
     latency.cdf.png. 
  1. The .log files currently consist of 4 columns as explained in the
     fio HOWTO. These are time, latency (us), direction (0=read), size
     (B).
  1. latency.time.png is a time series plot of the measured
     latency. latency.cdf.png is a plot of the CDF of the measured
     latency. Both files can be viewed using any reasonable image
     viewer.

## Quick Start (threads.sh)

  1. Ensure fio, python and gnuplot are installed and on your path.
  1. cd into top-level folder (fio-stuff by default).
  1. Check that the defaults in ./threads.sh are to your liking and
     match your system.
  1. Run the following:
     ```sudo ./threads.sh -f <filename> -i <iodepth> -r <rwmixread> -s <size>```
     [NB you may not need sudo depending on permissions]. Note that
     device needs to be a block device or regular file with rw
     permissions. Use -r 0 for write latency plots, the default is for
     read latency plots (-r 100).
  1. This should create two file called threads.log and
     threads.cpu.log and a plot called threads.png.
  1. threads.png is a plot of fio threads vs CPU utilization. It can
     be viewed using any reasonable image viewer.

## Updates

This code is open-source, we welcome patches and pull requests against
this codebase. You are under no obligation to submit code back to us
but we are hoping you will ;-).
