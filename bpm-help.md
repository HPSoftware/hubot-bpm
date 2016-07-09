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
