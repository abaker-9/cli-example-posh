# Example - SmartThings Switches CLI (PowerShell)

## SHORT DESCRIPTION

---

Get status and control SmartThings connected switches

---

## LONG DESCRIPTION

---

The sthelper.ps1 script is a CLI implementation to get devices and their status, and control SmartThings connected switches. This script was made possible thanks to the [node.js version](https://github.com/SmartThingsCommunity/cli-example-nodejs/) created by the SmartThings Community.

---

## Index

- [Requirements](README.md#requirements)
- [Installation](README.md#installation)
- [Module Functions](README.md#module-functions)
  - [sthelper](README.md#sthelper)


---


## Requirements

1. Powershell 5.1+
2. Access to SmarthThings Account

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

Get status and control SmartThings connected switches
