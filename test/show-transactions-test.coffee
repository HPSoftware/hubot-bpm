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
  '../src/bpm-show-transactions.coffee'])

nock.disableNetConnect()
process.env.HUBOT_BPM_CONFIG_PATCH = "test/bpm-config-test.json"

describe 'show-apps-test', ->
  @timeout 5000
  beforeEach (done) ->
    @room = helper.createRoom()
    setTimeout done, 1000

  afterEach ->
    @room.destroy()

  context 'Show transactions for application', ->
    beforeEach ->
      nocks = nock.load('test/rec-show-transactions.json')

    it 'Responds to bpm show transactions for app with dfa7d60e85b9b2385d0617f375acb9cd id', ->
      expectedResponse = 'Found following BTF and transactions:\n*BTF*: TC_Web_FF_avail: \tTruClient_TRN_Functions, TruClient_TRN_Miscellaneous, TruClient_TRN_Navigation, \n*BTF*: CVuser_get_hostname_with_define_available: \tGet Hostname. Define function, Multiline define, \n*BTF*: Web_phpbb_errors: \tForum error - no image, Forum error - script error, Forum error - auto-fail, Forum error - no web_find, Forum error - outlier transaction, Forum error - no web_reg_find, Forum error - step timeout, Forum error - page 404, Forum error - component 404, \n*BTF*: TC_Web_Chromium_SoE: \tTruClient_TRN_Navigation, TruClient_TRN_Miscellaneous, TruClient_TRN_Functions, \n*BTF*: WebHttpHtml1_txn_presta: \t4_transaction, 3_transaction, 1_transaction, 2_transaction, \n*BTF*: TruClientChrome_available6: \tTransaction 1, Transaction 3, Transaction 4, Transaction 2, \n*BTF*: CVuser_multiline_define_available: \tMultiline define, \n*BTF*: TruClient1253soe: \tTransaction 2, Transaction 1, \n*BTF*: WinSocket_error: \tSocket_close_unexisted, Socket0_close, Socket0_send_receive, Socket0_create, Socket_open_again, \n*BTF*: Web_phpbb_fail_start: \tphpbb fail to start, \n*BTF*: Web_phpbb_available: \tphpbb forum faq, phpbb frm str avail, \n*BTF*: Citrix_error_with_continue_on_error_single_ica: \tCitrix ICA Login, Citrix Error sync on text, Citrix Logout, \n*BTF*: CVuser_internal_func_system_available: \tGet Hostname, \n*BTF*: WebHttpHtml_presta_error: \t4_transaction, 3_transaction, 2_transaction, 1_transaction, \n*BTF*: TC_Web_Chromium_avail: \tTruClient_TRN_Functions, TruClient_TRN_Miscellaneous, TruClient_TRN_Navigation, \n*BTF*: SiebelCorrelationsSanity_Arrays: \tT7_URL_Start_Pass, T6_URL_Pass, T3_Post_query_pass, T5_Array_Pass, T2_Siebel_Comma_Pass, T1_Sieber_Pass, T4_Siebel_Start_Pass, \n*BTF*: CVuser_func_system_available: \tGet Hostname, \n*BTF*: SiebelCorrelationsSanity_Arrays_CoE_SoE: \tT2_Siebel_Comma_Pass, T4_Siebel_Start_Pass, T3_Post_query_Fail, T5_Array_Pass, T1_Sieber_Pass, T6_URL_Pass, T7_URL_Start_Pass, \n*BTF*: TruClient1_Available1: \tTransaction 3, Transaction 2, Transaction 1, \n*BTF*: Ajax_TruClient_IE_errors_TruClienWeb1_1253: \tTruClient_IE_TRN_addition_errors, TruClient_IE_TRN_error, \n*BTF*: TruClientFF_available5: \tTransaction 3, Transaction 2, Transaction 4, Transaction 1, \n*BTF*: TC_Web_Chromium_error: \tTruClient_TRN_Functions, TruClient_TRN_Navigation, TruClient_TRN_Miscellaneous, \n*BTF*: Citrix_available_single_ica_v3: \tCitrix Notepad, Citrix ICA Logout, Citrix ICA Login, \n*BTF*: Ajax_TruClient_IE_errors_TruClienWeb1: \tTruClient_IE_TRN_error, TruClient_IE_TRN_addition_errors, \n*BTF*: WinSocket_available: \tSocket0_send_receive, Socket0_close, Socket0_create, \n*BTF*: TC_Web_IE_avail: \tTruClient_TRN_Navigation, TruClient_TRN_Functions, TruClient_TRN_Miscellaneous, \n*BTF*: SiebelCorrelationsSanity_Arrays_CoE: \tT2_Siebel_Comma_Pass, T1_Sieber_Pass, T7_URL_Start_Pass, T4_Siebel_Start_Pass, T6_URL_Pass, T3_Post_query_Fail, T5_Array_Pass, \n*BTF*: TruClient1FF_Available: \tTransaction 1, Transaction 2, \n*BTF*: TC_FF_not_found_object_SoE_1: \tCannot  find object 1, Cannot  find object 2, \n*BTF*: TC_Web_IE_error: \tTruClient_TRN_Navigation, TruClient_TRN_Miscellaneous, TruClient_TRN_Functions, \n*BTF*: Citrix_error_single_ica: \tCitrix Logout, Citrix ICA Login, Citrix Error sync on text, \n*BTF*: SiebelCorrelationsSanity_Arrays_error_not found: \tT3_Post_query_Fail, T5_Array_Pass, T1_Sieber_Pass, T6_URL_Pass, T2_Siebel_Comma_Pass, T7_URL_Start_Pass, T4_Siebel_Start_Pass, \n*BTF*: WebHttpHtml1_txn_presta_success: \t4_transaction, 1_transaction, 2_transaction, 3_transaction, \n*BTF*: TruClient1253soe1: \tTransaction 1, Transaction 2, \n'
      command = 'bpm show transactions for app with dfa7d60e85b9b2385d0617f375acb9cd id'
      @room.user.say('alice', command).then =>
        expect(@room.messages).to.eql [
          ['alice', command]
          ['hubot', expectedResponse]
        ]
        console.log(@room.messages.toString())

nock.cleanAll()
