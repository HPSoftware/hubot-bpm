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
#   bpm show apps
#
# Notes:
#   Runs with user auth configured for bot...
#
# Author(s):
#   michael.mishaolov@hpe.com, arun.h-g@hpe.com

LWSSOUtils = require('./lib/lwsso-utils')
lwssoutils = new LWSSOUtils.LWSSOUtils()

module.exports = (robot) ->
  robot.hear /bpm show apps/i, (msg) ->
    instancesConfig = lwssoutils.invokeScript robot, msg
    options = lwssoutils.getLWSSOAuth robot, msg, instancesConfig
    cookie = ''
    lwssoutils.doHTTPGet robot, msg, options, (robot, msg , res) ->
      cookie = res.headers["set-cookie"]
      getApplications robot, msg, cookie, options.bpmInstance

#Perform call to get applications API
getApplications = (robot, msg, cookie, bpmInstance) ->
  options =
    hostname: bpmInstance['host'],
    path: "/topaz/eum/admin/applications/flatApplications",
    protocol: "#{bpmInstance['protocol']}:",
    method: 'GET',
    headers:
      'Set-Cookie': cookie
      'Cookie': cookie

  lwssoutils.doHTTPGet robot, msg, options, (robot, msg , res) ->
    content = ''
    result = 'Application Name, Application ID\n'
    res.on 'data', (chunk) ->
      content += chunk.toString()
    res.on 'end', () ->
      robot.logger.debug "@BPM: Returning API response content"
      data = JSON.parse(content)
      for application in data.flatApplications
        result += "#{application['name']}, #{application['id']} \r\n"
      msg.send result
