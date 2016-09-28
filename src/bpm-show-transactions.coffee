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
#   bpm show transactions for app with id <appID>
#
# Author:
#   arun.h-g@hpe.com

LWSSOUtils = require('./lib/lwsso-utils')
lwssoutils = new LWSSOUtils.LWSSOUtils()

module.exports = (robot) ->
  robot.hear /bpm show transactions for app with id (.*)/i, (msg) ->
    instancesConfig = lwssoutils.invokeScript robot, msg
    options = lwssoutils.getLWSSOAuth robot, msg, instancesConfig
    cookie = ''
    lwssoutils.doHTTPGet robot, msg, options, (robot, msg , res) ->
      cookie = res.headers["set-cookie"]
      getTransactions robot, msg, cookie, options.bpmInstance, {appID:msg.match[1].trim()}

#Perform call to get applications API
getTransactions = (robot, msg, cookie, bpmInstance, queryParams) ->
  options =
    hostname: bpmInstance['host'],
    path: "/topaz/eum/admin/applications/" + queryParams.appID + "/transactions",
    protocol: "#{bpmInstance['protocol']}:",
    method: 'GET',
    headers:
      'Set-Cookie': cookie
      'Cookie': cookie

  lwssoutils.doHTTPGet robot, msg, options, (robot, msg , res) ->
    content = ''
    result = 'BTF: Transactions..\n'
    res.on 'data', (chunk) ->
      content += chunk.toString()
    res.on 'end', () ->
      robot.logger.debug "@BPM: Returning API response content"
      data = JSON.parse(content)
      for application in data.flatBtfs
        result += "#{application['name']}: "
        for application in application.transactions
          result += "#{application['name']}, "
        result += "\n"
      msg.send result