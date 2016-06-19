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


class Utils
  # Public:
  loadJSON: (name) ->
    name = name.trim()
    fileName="./#{name}.json"
    fs = require 'fs'
    jsonString = fs.readFileSync fileName, 'utf8'
    return JSON.parse jsonString

# Export
module.exports = new Utils()