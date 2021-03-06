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
ConfigUtils = require('./lib/config-utils')
configUtils = new ConfigUtils.ConfigUtils()

module.exports = (robot) ->
  robot.hear /bpm show apps$/i, (msg) ->
    bpmInstance = configUtils.getDefaultInstance robot
    options = lwssoutils.getLWSSOAuth robot, msg, bpmInstance
    cookie = ''
    lwssoutils.doHTTPGet robot, msg, options, (robot, msg , res) ->
      cookie = res.headers["set-cookie"]
      getApplications robot, msg, cookie, bpmInstance
  robot.hear /bpm show apps for instance (.*)/i, (msg) ->
    bpmInstance = configUtils.getInstance msg.match[1].trim(), robot
    options = lwssoutils.getLWSSOAuth robot, msg, bpmInstance
    cookie = ''
    lwssoutils.doHTTPGet robot, msg, options, (robot, msg , res) ->
      cookie = res.headers["set-cookie"]
      getApplications robot, msg, cookie, bpmInstance

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
    content.format
    res.on 'data', (chunk) ->
      content += chunk.toString()
    res.on 'end', () ->
      robot.logger.debug "@BPM: Returning API response content"
      data = JSON.parse(content)
      result = 'Found following applications:\n'
      for application in data.flatApplications
        result += "*Name*: #{application['name']}, *ID*: `#{application['id']}`\n"
      msg.send result
