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
lwssoUtils = new LWSSOUtils.LWSSOUtils()
DateUtils = require('./lib/date-utils')
dateUtils = new DateUtils.DateUtils()
ConfigUtils = require('./lib/config-utils')
configUtils = new ConfigUtils.ConfigUtils()

module.exports = (robot) ->
  robot.hear /bpm show status of app with id (.*) for the past (.*)/i, (msg) ->
    bpmInstance =  configUtils.getDefaultInstance robot
    options = lwssoUtils.getLWSSOAuth robot, msg, bpmInstance
    cookie = ''
    lwssoUtils.doHTTPGet robot, msg, options, (robot, msg , res) ->
      cookie = res.headers["set-cookie"]
      getAppStatus robot, msg, cookie, bpmInstance, msg.match[1].trim(), msg.match[2].trim()


#Perform call to get applications API
getAppStatus = (robot, msg, cookie, bpmInstance, appID, frequency) ->
  toDate = new Date().getTime() // 1000 #we need time in seconds
  fromDate = dateUtils.getRangeFromDate(frequency).getTime() // 1000 #we need time in seconds
  appIDsArray = [];
  appIDsArray.push(appID)
  robot.logger.debug "@BPM: timezone offset: "+ dateUtils.getTimeZoneOffset()
  postData = {
    "applicationIds":  appIDsArray,
    "clientGmtOffset": dateUtils.getTimeZoneOffset(),
    "timeTo": toDate,
    "timeFrom": fromDate,
    "timeUnit": "HOUR",
    "timeUnitsNum": 1,
    "timeView": frequency
  };
  options =
    hostname: bpmInstance['host'],
    path: "/eum-web/bsmproxy?method="+ encodeURI("eumReports/applicationOverview/overview"),
    protocol: "#{bpmInstance['protocol']}:",
    method: 'POST',
    headers:
      'Set-Cookie': cookie
      'Cookie': cookie
      'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36'
      'Content-Type': 'application/json'
      'Connection': 'keep-alive'
      'Content-Length': Buffer.byteLength(JSON.stringify(postData))
  lwssoUtils.doHTTPRequest robot, msg, options, JSON.stringify(postData), (robot, msg , res) ->
    content = ''
    res.on 'data', (chunk) ->
      content += chunk.toString()
    res.on 'end', () ->
      robot.logger.debug "@BPM: Returning API response content"
      msg.send content
