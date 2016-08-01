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

# Public: List configured BMP instances and their description
#
# Configuration:
#   HUBOT_BPM_CONFIG_PATCH - external configuration file.
#   If not specified bpm-config.json fromm root directory will be used
#
# Commands:
#   bpm show config
#
# Author:
#   michael.mishaolov@hpe.com

IOUtils = require('./lib/io-utils')
utils = new IOUtils.FileUtils()

###########################################################################
module.exports = (robot) ->
  robot.hear /bpm show config/i, (msg) ->
    returnBPMConfig robot, msg

returnBPMConfig = (robot, msg) ->
  configPatch = process.env.HUBOT_BPM_CONFIG_PATCH
  if configPatch?
    instancesConfig = utils.loadExternalJSON(robot,configPatch)
  else
    instancesConfig = utils.loadJSON(robot,"bpm-config")

  result = ''
  for instanceName, instanceConfig of instancesConfig['instances']
    result += "`#{instanceName}`, #{instanceConfig['description']} \r\n"
  msg.send result
