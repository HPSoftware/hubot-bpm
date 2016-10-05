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


# Description
#   Help functions script
#
# Configuration:
#   N/A
#
# Commands:
#   N/A
#
# Notes:
#   Load script using: functions = require('./lib/utils')
#
# Author:
#   michael.mishaolov@hpe.com

fs = require 'fs'

class FileUtils
  constructor: ->

  # Loads JSON config files from root directory and return content as JSON Object
  loadJSON: (robot,name) ->
    name = name.trim()
    fileName="#{name}.json"
    robot.logger.debug "@BPM: Loading local JSON #{fileName}"
    jsonString =  @loadFile(robot, fileName)
    return JSON.parse jsonString

  # Loads external JSON config files from root directory and return content as JSON Object
  loadExternalJSON: (robot,path) ->
    robot.logger.debug "@BPM: Loading JSON #{path}"
    jsonString =  @loadExternalFile(robot, path)
    return JSON.parse jsonString

  # Loads local file and returns content as string
  loadFile: (robot,fileName) ->
    fileName = fileName.trim()
    directory = fs.realpathSync(__dirname)
    path = "#{directory}/../../#{fileName}"
    robot.logger.debug "@BPM: Loading local file #{path}"
    return @loadExternalFile robot, path

  # Loads external file and returns content as string
  loadExternalFile: (robot,path) ->
    path = path.trim()
    robot.logger.debug "@BPM: Loading file #{path}"
    return fs.readFileSync path, 'utf8'

  encodeInBase64: (string) ->
    encodedString = new Buffer(string).toString('base64')
    return encodedString

  decodeInBase64: (string) ->
    encodedStringArray = string.split " "
    encodedString = encodedStringArray[1]
    decodedString = new Buffer(encodedString, 'base64').toString('ascii')
    return decodedString


module.exports.FileUtils = FileUtils