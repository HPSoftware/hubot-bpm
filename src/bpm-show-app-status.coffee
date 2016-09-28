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

# Public: Returns configured applications list
#
# Commands:
#   bpm show status of app with id <appID> for the past <hour/day/month/week>
#
# Author:
#   arun.h-g@hpe.com

LWSSOUtils = require('./lib/lwsso-utils')
lwssoutils = new LWSSOUtils.LWSSOUtils()
DateUtils = require('./lib/date-utils')
dateUtils = new DateUtils.DateUtils()
querystring = require('querystring');

module.exports = (robot) ->
  robot.hear /bpm show status of app with id (.*) for the past (.*)/i, (msg) ->
    instancesConfig = lwssoutils.invokeScript robot, msg
    options = lwssoutils.getLWSSOAuth robot, msg, instancesConfig
    cookie = ''
    lwssoutils.doHTTPGet robot, msg, options, (robot, msg , res) ->
      cookie = res.headers["set-cookie"]
      getAppStatus robot, msg, cookie, options.bpmInstance, {appID:msg.match[1].trim()}, {appID:msg.match[2].trim()}

#Perform call to get applications API
getAppStatus = (robot, msg, cookie, bpmInstance, appID, freq) ->
  toDate = new Date().valueOf()
  fromDate = dateUtils.getFromDate(freq).valueOf()
  postData = querystring.stringify({
    "applicationIds": [
      appID
    ],
    "clientGmtOffset": dateUtils.getTimeZone(),
    "timeTo": toDate,
    "timeFrom": fromDate,
    "timeUnit": "DAY",
    "timeUnitsNum": 1,
    "timeView": freq
  });
  options =
    hostname: bpmInstance['host'],
    path: "topaz/eum/reports/eumReports/applicationOverview/overview",
    protocol: "#{bpmInstance['protocol']}:",
    method: 'POST',
    headers:
      'Set-Cookie': cookie
      'Cookie': cookie
      'Content-Type': 'application/json'
      'Content-Length': Buffer.byteLength(postData)
      'Connection': 'keep-alive'
  lwssoutils.doHTTPRequest robot, msg, options, postData, (robot, msg , res) ->
    content = ''
    res.on 'data', (chunk) ->
      content += chunk.toString()
    res.on 'end', () ->
      robot.logger.debug "@BPM: Returning API response content"
      data = JSON.parse(content)
      msg.send data
