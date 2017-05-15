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

# Public: library to simplify configuration load.
#
# Author:
#    michael.mishaolov@hpe.com

IOUtils = require('./io-utils')
utils = new IOUtils.FileUtils()

class ConfigUtils
  constructor: ->

#Load json and build InstanceConfig
  getBotConfig: (robot) ->
    configPatch = process.env.HUBOT_BPM_CONFIG_PATCH
    if configPatch?
      instancesConfig = utils.loadExternalJSON(robot,configPatch)
    else
      instancesConfig = utils.loadJSON(robot,"bpm-config")
    return instancesConfig

#Get default instance name
  getDefaultInstance: (robot) ->
    instancesConfig = @getBotConfig(robot)
    for instanceName, instanceConfig of instancesConfig['instances']
      return instanceConfig

#Get instance name
  getInstance: (instance, robot) ->
    instancesConfig = @getBotConfig(robot)
    for instanceName, instanceConfig of instancesConfig['instances']
      if(instanceName == instance)
        return instanceConfig

module.exports.ConfigUtils = ConfigUtils
