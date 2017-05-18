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
  '../src/bpm-show-app-status.coffee'])

nock.disableNetConnect()
process.env.HUBOT_BPM_CONFIG_PATCH = "test/bpm-config-test.json"

describe 'show-app-status-test', ->
  @timeout 5000
  beforeEach (done) ->
    @room = helper.createRoom()
    setTimeout done, 1000

  afterEach ->
    @room.destroy()

  context 'Show application status', ->
    beforeEach ->
      nocks = nock.load 'test/rec-show-app-status.json'
      for scope in nocks
        scope.filteringRequestBody (body, aRecordedBody)->
          body = ""
          body


    it 'Responds to bpm show status of app with id dbfc4bf683204c89d5a0f79692ecbc5b for the past hour timeframe', ->
      expectedResponse = 'Application status in the last hour:\n*Average availability*: 0\n*Average response*: 0\n*Total failures*: 0\n*Total volume*: 0\n'
      command = 'bpm show status of app with id dbfc4bf683204c89d5a0f79692ecbc5b for the past hour timeframe'
      @room.user.say('alice', command).then =>
        expect(@room.messages).to.eql [
          ['alice', command]
          ['hubot', expectedResponse]
        ]
        console.log(@room.messages.toString())

nock.cleanAll()
