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


Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper([
  '../node_modules/hubot-enterprise/src/0_bootstrap.coffee',
  '../src/hubot-bpm.coffee'])

describe 'hubot-bpm', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to hubot-bpm create', ->
    @room.user.say('alice', '@hubot hubot-bpm create issue').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot hubot-bpm create issue']
        ['hubot', '@alice in hubot-bpm create']
      ]

  it 'hears hubot-bpm update', ->
    @room.user.say('bob', 'hubot-bpm update issue').then =>
      expect(@room.messages).to.eql [
        ['bob', 'hubot-bpm update issue']
        ['hubot', 'in hubot-bpm update']
      ]
