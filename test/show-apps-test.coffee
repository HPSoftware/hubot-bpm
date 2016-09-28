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

nock = require 'nock'
Helper = require('hubot-test-helper')
chai = require 'chai'
expect = chai.expect

helper = new Helper([
  '../node_modules/hubot-enterprise/src/0_bootstrap.coffee',
  '../src/bpm-show-apps.coffee'])

nock.disableNetConnect()
process.env.HUBOT_BPM_CONFIG_PATCH = "test/bpm-config-test.json"

describe 'show-apps-test', ->
  beforeEach (done) ->
    @room = helper.createRoom()
    setTimeout done, 1000

  afterEach ->
    @room.destroy()

  context 'bpm show apps', ->
    beforeEach ->
      nocks = nock.load('test/show-apps.json')

    it 'Responds to bpm show apps', ->
      expectedResponse = 'Application Name, Application ID'
      command = 'bpm show apps'
      @room.user.say('alice', command).then =>
        expect(@room.messages).to.eql [
          ['alice', command]
          ['hubot', expectedResponse]
        ]
        console.log(@room.messages.toString())

nock.cleanAll()