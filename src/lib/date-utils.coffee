###
Copyright 2016 Hewlett-Packard Development Company, L.P.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing,
Software distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
###

# Public: library to handle:
# - get from-to timestamp for reporting
# - get timezone
#
# Author:
#   arun.h-g@hpe.com

http = require 'http'
fs = require 'fs'
IOUtils = require('./io-utils')
utils = new IOUtils.FileUtils()

class DateUtils
  constructor: ->

#get FromDate for the range argument passed
  getFromDate: (robot, range) ->
    fromDate = new Date()
    if range == "hour"
      currHour = toDate.getHours()
      --currHour
      fromDate.setHours(currHour)
    if range == "day"
      currDate = toDate.getDate()
      --currDate
      fromDate.setDate(currDate)
    if range == "week"
      currDate = toDate.getDate()
      currDate = currDate - 7
      fromDate.setDate(currDate)
    if range == "month"
      currMonth = toDate.getMonth()
      --currMonth
      fromDate.setMonth(currMonth)
    return fromDate

#get FromDate for the range argument passed
  getTimeZone: (robot) ->
    currDate = new Date()
    split = currDate.toString().split " "
    return split[5]

module.exports.DateUtils = DateUtils