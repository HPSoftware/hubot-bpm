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

# Public: Prints help witch commands for bot control
#
# Commands:
#   bpm help
#
# Notes:
#   Provides formatted output for Slack adaptor
#
# Author:
#   michael.mishaolov@hpe.com

IOUtils = require('./lib/io-utils')
utils = new IOUtils.FileUtils()

module.exports = (robot) ->
  robot.hear /bpm help/i, (msg) ->
    returnHelpMessage robot, msg

returnHelpMessage = (robot, msg) ->
  helpText = utils.loadFile(robot,"bpm-help.md")
  if robot.adapterName is 'slack'
    robot.emit 'slack.attachment', {channel: msg.message.room, text: helpText.replace /\*\*/g, "*"}
  else
    msg.send helpText
