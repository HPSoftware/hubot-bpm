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


# Public: Invokes BPM script
#
# Configuration:
#   N/A
#
# Commands:
#   bpm invoke script <Scripts separated by ;> from btf <BTFs separated by ;> from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]
#   bpm invoke all from btf <BTFs separated by ;> from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]
#   bpm invoke all from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]
#
# Author:
#   michael.mishaolov@hpe.com

Utils = require('./lib/io-utils')
http = require 'http'

utils = new Utils()


module.exports = (robot) ->
  #Invoke specific script from specific BTF
  robot.hear /bpm invoke script (.*) from btf (.*) from app (.*) for host (.*) from (.*) location$/i, (msg) ->
    invokeScript robot, msg, {scriptName:msg.match[1].trim(),btfName: msg.match[2].trim(), applicationName: msg.match[3].trim(), hostName: msg.match[4].trim(),geoLocation: msg.match[5].trim(), bpmInstanceName: "default"}
  robot.hear /bpm invoke script (.*) from btf (.*) from app (.*) for host (.*) from (.*) location use bpm instance (.*)/i, (msg) ->
    invokeScript robot, msg, {scriptName:msg.match[1].trim(),btfName: msg.match[2].trim(), applicationName: msg.match[3].trim(), hostName: msg.match[4].trim(),geoLocation: msg.match[5].trim(), bpmInstanceName: msg.match[6].trim()}
  # Invoke all scripts from specific BTF
  robot.hear /bpm invoke all from btf (.*) from app (.*) for host (.*) from (.*) location$/i, (msg) ->
    invokeScript robot, msg, {scriptName:null,btfName: msg.match[1].trim(), applicationName: msg.match[2].trim(), hostName: msg.match[3].trim(),geoLocation: msg.match[4].trim(), bpmInstanceName: "default"}
  robot.hear /bpm invoke all from btf (.*) from app (.*) for host (.*) from (.*) location use bpm instance (.*)/i, (msg) ->
    invokeScript robot, msg, {scriptName:null,btfName: msg.match[1].trim(), applicationName: msg.match[2].trim(), hostName: msg.match[3].trim(),geoLocation: msg.match[4].trim(), bpmInstanceName: msg.match[5].trim()}
  #Invoke all scripts from all BTFs
  robot.hear /bpm invoke all from app (.*) for host (.*) from (.*) location$/i, (msg) ->
    invokeScript robot, msg, {scriptName:null,btfName: null, applicationName: msg.match[1].trim(), hostName: msg.match[2].trim(),geoLocation: msg.match[3].trim(), bpmInstanceName: "default"}
  robot.hear /bpm invoke all from app (.*) for host (.*) from (.*) location use bpm instance (.*)/i, (msg) ->
    invokeScript robot, msg, {scriptName:null,btfName: null, applicationName: msg.match[1].trim(), hostName: msg.match[2].trim(),geoLocation: msg.match[3].trim(), bpmInstanceName: msg.match[4].trim()}


#The main logic controller method
invokeScript = (robot, msg, queryParams) ->

  instancesConfig = utils.loadJSON(robot,"bpm-config")
  request = buildRequest robot,instancesConfig, queryParams
  callRESTAPI request, robot, msg, formatAndSendMessage


#Builds url including query parameters for invoke script BPM API
buildRequest = (robot, instancesConfig, queryParams) ->
  robot.logger.debug "@BPM: config loaded"
  if queryParams.bpmInstanceName == "default"
    for instanceName, instanceConfig of instancesConfig['instances']
      queryParams.bpmInstanceName = instanceName
      break
  bpmInstance = instancesConfig['instances'][queryParams.bpmInstanceName]

  path = "?instanceUrl=" + encodeURI "#{bpmInstance['protocol']}://#{bpmInstance['host']}/topaz"
  path = path + "&hostName=" + encodeURI queryParams.hostName
  path = path + "&location=" + encodeURI queryParams.geoLocation
  path = path + "&applicationName=" + encodeURI queryParams.applicationName
  if queryParams.btfName?
    path = path + "&btfName=" + encodeURI queryParams.btfName
  if queryParams.scriptName?
    path = path + "&scriptName=" + encodeURI queryParams.scriptName

  robot.logger.debug "@BPM: generated query for invokeScript API: #{path}"
  path = "/rest/invokeScript" + path

  options =
    hostname: bpmInstance['host'],
    port: bpmInstance['port'],
    path: path,
    protocol: "#{bpmInstance['protocol']}:",
    method: 'GET',
    headers:
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': bpmInstance['authorization']
  return options

#Calls BPM Invoke Script REST API
callRESTAPI = (requestOptions, robot, msg, callback) ->

  msg.send "Working on your request @#{msg.envelope.user.name}, it may take some time."
  req = http.get requestOptions, (res) ->
    if res.statusCode == 200
      content = ''
      res.on 'data', (chunk) ->
        content += chunk.toString()
      res.on 'end', () ->
        robot.logger.debug "@BPM: Parsing API content"
        responseJSON = JSON.parse content
        callback robot, msg, responseJSON
     else
      robot.logger.debug "@BPM: Received wrong response code: #{res.statusCode}"
      msg.send "Sorry something happen during processing your request @#{msg.envelope.user.name}: received wrong response code: #{res.statusCode}"
  req.on 'error', (e) ->
    robot.logger.debug "@BPM:Some error accrued during executing API call: #{e.message}"
    msg.send "Sorry some error happen during processing your request @#{msg.envelope.user.name}: #{e.message}"


formatAndSendMessage = (robot, msg, responseJSON) ->

  robot.logger.debug "@BPM: Preparing response message"
  attachments = []
  for btfName, btfDetails of responseJSON['scriptsData']
    errors = false
    fields = []
    for transaction in btfDetails['transactions']
      transactionName = "Transaction: #{transaction['name']}"
      transactionDescription = "Duration: #{transaction['duration']} ms"
      isShort = true
      if transaction['status'] == 1
        errors = true
        isShort = false
        transactionDescription+=", Status: ERROR"
        for transactionError in transaction['transErrors']
          transactionDescription+="\n#{transactionError['description']}"
      else
        transactionDescription+=", Status: OK"
      field =
        "title": transactionName,
        "value": transactionDescription,
        "short": isShort
      fields.push field
    attachment =
      "color": if errors then 'danger' else 'good'
      "pretext": "#{btfName} Business Transaction Flow Breakdown:",
      "title": "Details:",
      "fields": fields
    attachments.push attachment
  robot.logger.debug "@BPM: Sending message"
  if robot.adapterName is 'slack'
    robot.emit 'slack.attachment', {channel: msg.message.room, attachments:attachments}
  else
    msg.send "Sorry currently only Slack is supported :("