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
#   arun.h-g@hpe.com,  michael.mishaolov@hpe.com

class DateUtils
  constructor: ->

#get FromDate for the range argument passed
  getRangeFromDate: (range) ->
    date = new Date()
    if range == "hour"
      date.setHours(date.getHours()-1)
    if range == "day"
      date.setDate(date.getDate()-1)
    if range == "week"
      date.setDate(date.getDate()-7)
    if range == "month"
      date.setMonth(date.getMonth()-1)
    return date

#get FromDate for the range argument passed
  getTimeZoneOffset: () ->
    offset = new Date().getTimezoneOffset()/60
    dt = new Date(Math.abs(offset) * 3600000 + new Date(2000, 0).getTime()).toTimeString();
    result = if offset < 0 then '-' else '+'
    result+=(dt.substr(0,2) + ":" + dt.substr(3,2))
    return result

module.exports.DateUtils = DateUtils