The BPM bot supporting next set of commands

**Show help**

_Description_: Shows this help

_Syntax_: `bpm help`

**Show configuration**

_Description_: List configured BMP instances and their description

_Syntax_: `bpm show config`

**Invoke BPM script**

**Invoke selected script(s) from selected BTF**

_Description_: Invokes specific BPM script(s) using specific Business Transaction Flow (BTF)

_Syntax_: `bpm invoke script <Scripts separated by ;> from btf <BTFs separated by ;> from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]`

_Example_:
`bpm invoke script myDemoApp from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK use bpm instance bpm_instance_1`
`bpm invoke script myDemoApp from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK`

**Invoke all scripts from BTF**

_Description_: Invokes all BPM scripts from specific Business Transaction Flow (BTF)

_Syntax_: `bpm invoke all from btf <BTFs separated by ;> from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]`

_Example_:
`bpm invoke all from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK use bpm instance bpm_instance_1`
`bpm invoke all from btf myDemoApp from app demo for host myd-london-bpm_london from location London, UK`

**Invoke all scripts from all BTFs**

_Description_: Invokes all BPM scripts from all Business Transaction Flows (BTFs) for selected application

_Syntax_: `bpm invoke all from app <Application Name> for host <Host Name> from <Location> location[ use bpm instance <BPM Instance Name>]`

_Example_:
`bpm invoke all from app demo for host myd-london-bpm_london from location London, UK use bpm instance bpm_instance_1`
`bpm invoke all from app demo for host myd-london-bpm_london from location London, UK`

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
