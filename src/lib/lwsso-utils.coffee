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
# - login to bsm and return lwsso cookie
# - load bpm-config json
# - do http rest get
# - do http rest request
#
# Author:
#   arun.h-g@hpe.com

http = require 'http'
fs = require 'fs'
IOUtils = require('./io-utils')
utils = new IOUtils.FileUtils()

class LWSSOUtils
  constructor: ->

  #Generic function to perform HTTP get calls
  doHTTPGet: (robot, msg, options, callback) ->
    req = http.get options, (res) ->
      if res.statusCode == 200
        console.log "success"
        callback robot, msg , res
      else
        console.log "here6"
        robot.logger.debug "@BPM: Received wrong response code: #{res.statusCode}"
        msg.send "Sorry, Error occured during processing your request @#{msg.envelope.user.name}: received wrong response code: #{res.statusCode}"
    req.on 'error', (e) ->
      robot.logger.debug "@BPM:Error occured during executing API call: #{e.message}"
      msg.send "Sorry, Error occured during processing your request @#{msg.envelope.user.name}: #{e.message}"

  #Generic function to perform HTTP request calls
  doHTTPRequest: (robot, msg, options, postData, callback) ->
    req = http.request options, (res) ->
      if res.statusCode == 200
        console.log "success"
        callback robot, msg , res
      else
        console.log "here5"
        robot.logger.debug "@BPM: Received wrong response code: #{res.statusCode}"
        msg.send "Sorry, Error occured during processing your request @#{msg.envelope.user.name}: received wrong response code: #{res.statusCode}"
    req.on 'error', (e) ->
      robot.logger.debug "@BPM:Some error accrued during executing API call: #{e.message}"
      msg.send "Sorry, Error occured during processing your request @#{msg.envelope.user.name}: #{e.message}"
    req.write(postData)
    req.end()


  #Authenticate to APM and get LWSSO cookie
  getLWSSOAuth: (robot, msg, bpmInstance) ->
    decodedString = utils.decodeInBase64(bpmInstance['authorization'])
    decodedStringArray = decodedString.split ":"
    login = decodedStringArray[0]
    password = decodedStringArray[1]
    options =
      hostname: bpmInstance['host'],
      path: "/topaz/TopazSiteServlet?userlogin="+login+"&userloginValue="+login+"&userpassword="+password+"&autologin=yes&requestType=login",
      protocol: "#{bpmInstance['protocol']}:",
      method: 'GET',
      headers:
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'User-Agent': 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36'
    return options

module.exports.LWSSOUtils = LWSSOUtils
