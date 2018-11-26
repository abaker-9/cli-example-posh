# Example - SmartThings Switches CLI (PowerShell)

Get status and control SmartThings connected switches

The sthelper.ps1 script is a CLI implementation that uses REST to get devices and their status, and control SmartThings connected switches. This script was made possible thanks to the [node.js version](https://github.com/SmartThingsCommunity/cli-example-nodejs/) created by the SmartThings Community.

## Requirements

1. Powershell 5.1+
2. Access to SmartThings Account

## Installation

1. Clone or download this repository.
1. Create a [personal access token](https://account.smartthings.com/tokens/new) with **all Devices scopes selected**. Copy or store this token in a secure place.
1. Create an environment variable named `SMARTTHINGS_CLI_TOKEN`, and set its value to your personal access token obtained in previous step).

```PowerShell
$env:SMARTTHINGS_CLI_TOKEN ='<token>'
```

---

## Script Help

### [sthelper](./docs/sthelper.md)<!--- INDEX_INDENT -->
