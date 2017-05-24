# ChatOps Bot for HPE Business Process Monitor (BPM)
![hubot-bpm](https://github.com/HPSoftware/hubot-bpm/blob/master/resources/bpm_bot_logo.png)

## Overview
Business Process Monitor (BPM) is one of the HPE Application Performance Management (APM) data
collectors. BPM proactively monitors enterprise applications in real time, identifying performance and
availability problems before users experience them. It enables you to monitor sites from various locations,
emulating the end-user experience, and so assess site performance from different client perspectives.

This is a project enable BPM users to connect BPM to ChatOps tools and contains the source code of a npm package for a Hubot integration.

## Installation

### Hubot Configuration
1. Generate new Hubot deployment by running `yo hubot-enterprise` command or use an existing deployment you already have.
2. From the Hubot main directory, run the following command:
`npm install git+https://github.com/HPSoftware/hubot-bpm.git --save `
    * This command will install hubot-bpm package on your Hubot.
3. Then add `hubot-bpm` to your `external-scripts.json` file contains list of packages from npm:
```json
[
  "hubot-bpm"
]
```

For more information about hubot-enterprise project please refer to hubot-enterprise [Wiki](https://github.com/eedevops/hubot-enterprise/wiki/bootstrap)

## Config

Bot example configuration stored in config file at: bpm-config.json

```json
{
  "instances":{
    "bpm_instance_1": {
      "description":"BPM instance 1",
      "host": "[bsm host]",
      "bpm-host": "[bpm host]",
      "port":"2696",
      "protocol": "[http | https]",
      "authorization": "Basic [your base64 encoded auth]"
    },
    "bpm_instance_x": {
      "description":"BPM instance X",
      "host": "[your host]",
      "bpm-host": "[bpm host]",
      "port":"2696",
      "protocol": "[http | https]",
      "authorization": "Basic [your base64 encoded auth]"
    }
  }
}
```

* In order to configure BPM bot you need edit bpm-config.json file and specify you running BPM instances that you want to access from through you bot.
* `Authorization` parameter is the authorization required to authenticate against your BPM instance in basic authentication format.
  * The username and password are combined with a single colon.
  * The resulting string is encoded using the RFC2045-MIME variant of Base64, except not limited to 76 char/line.
  * The authorization method and a space i.e. "Basic " is then put before the encoded string.
  For more details about basic auth please check: [Wiki](https://en.wikipedia.org/wiki/Basic_access_authentication)
* The first configured instance will be used by bot as default instance for all operations.
  * You can always override the default instance by specifying in bot command that BPM instance to use.

* Please note that the field "bpm-host" in the json is optional. If this isn't provided, the bot assumes that bpm is running in the bsm host.

**Example of configuration file:**
```json
{
  "instances":{
    "bpm_instance_london": {
      "description":"BPM instance runing at london",
      "host": "myd-london-bsm.com",
      "bpm-host": "myd-london-bpm.com",
      "port":"2696",
      "protocol": "http",
      "authorization": "Basic YWRtaW46YWRtaW4="
    }
  }
}
```
You can also point bot to use configuration file from external location.
In order to do it you need define `HUBOT_BPM_CONFIG_PATCH` system variable that should include path to external configuration file.

### BPM Configuration

In order to use bot functionality BPM REST API should be enabled.
To turn on REST API functionality you need perform following steps:

1. Stop the BPM service.
2. Open the following file in a text editor:
…\BPM\ServletContainer\webapps\ROOT\WEB-INF\web.xml
3. In the web-app tag, add the following:
```XML
    <servlet>
        <servlet-name>spring</servlet-name>
        <servlet-class>org.springframework.web.servlet.</servlet-class>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>spring</servlet-name>
        <url-pattern>/rest/*</url-pattern>
    </servlet-mapping>
```
4. Start the BPM service.

## Commands support

The BPM bot supporting next set of commands

**Show help**

_Description_: Shows this help

_Syntax_: `bpm help`

**Show configuration**

_Description_: List configured BPM instances and their description

_Syntax_: `bpm show config`

**Invoke selected script(s) from selected BTF**

_Description_: Invokes specific BPM script(s) using specific Business Transaction Flow (BTF)

_Syntax_: `bpm invoke script <Scripts separated by ;> from btf <BTFs separated by ;> from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]`

_Example_:
* `bpm invoke script myDemoApp from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK use bpm instance bpm_instance_1`
* `bpm invoke script myDemoApp from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK`

**Invoke all scripts from BTF**

_Description_: Invokes all BPM scripts from specific Business Transaction Flow (BTF)

_Syntax_: `bpm invoke all from btf <BTFs separated by ;> from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]`

_Example_:
* `bpm invoke all from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK use bpm instance bpm_instance_1`
* `bpm invoke all from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK`

**Invoke all scripts from all BTFs**

_Description_: Invokes all BPM scripts from all Business Transaction Flows (BTFs) for selected application

_Syntax_: `bpm invoke all from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]`

_Example_:
* `bpm invoke all from app demo for host myd-london-bpm_london from location London, UK use bpm instance bpm_instance_1`
* `bpm invoke all from app demo for host myd-london-bpm_london from location London, UK`

**Show applications list**

_Description_: Shows application list for the first instance in configuration.

_Syntax_: `bpm show apps`

**Show applications list for a particular instance**

_Description_: Shows application list for the requested instance in configuration.

_Syntax_: `bpm show apps for instance <instanceName>`

**Show application status**

_Description_: Shows application status of the application in terms of availability, performance and failures for the requested duration.

_Syntax_: `bpm show status of app with id <appID> for the past <hour|day|week|month> timeframe`

**Show application status for a particular instance**

_Description_: Shows application status of the application in terms of availability, performance and failures for the requested duration for the requested instance in configuration.

_Syntax_: `bpm show status of app with id <appID> for the past <hour|day|week|month> for instance <instanceName>`

**Show transactions for an application**

_Description_: Shows all the transactions under an application.

_Syntax_: `bpm show transactions for app with <appID> id`

**Show transactions for an application for a particular instance**

_Description_: Shows all the transactions under an application for the requested instance in configuration.

_Syntax_: `bpm show transactions for app with <appID> id for instance <instanceName>`

**Show locations for an application**

_Description_: Shows all the locations on which the application is configured to run.

_Syntax_: `bpm show locations for app with <appID> id`

**Show locations for an application for a particular instance**

_Description_: Shows all the locations on which the application is configured to run for the requested instance in configuration.

_Syntax_: `bpm show locations for app with <appID> id for instance <instanceName>`

## Limitations
* https isn't supported
