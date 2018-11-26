# sthelper.ps1

## SYNOPSIS

Get status and control SmartThings connected switches

## SYNTAX

```powershell
sthelper [-Command <>] [-Level <int>] [-Color <string>] [-URI <string>] [-Token <string>] [-DeviceName <string[]>]
```

## DESCRIPTION

The sthelper.ps1 script is a CLI implementation to get devices and their status, and control SmartThings connected switches

## Examples

### Example 1

```powershell
.\sthelper.ps1 list

Lists all devices
```

### Example 2

```powershell
.\sthelper.ps1 list Breakfast

Lists a specific device
```

### Example 3

```powershell
.\sthelper.ps1 status Breakfast

Shows status of single device
```

### Example 4

```powershell
.\sthelper.ps1 status

Shows status of all devices
```

### Example 5

```powershell
.\sthelper.ps1 status Breakfast 'Rachio Sprinkler Controller' -verbose

Shows status of multiple devices
```

### Example 6

```powershell
.\sthelper turnon Breakfast

Turns a device on
```

### Example 7

```powershell
.\sthelper turnoff Breakfast

Turns a device off
```

### Example 8

```powershell
.\sthelper turnon Breakfast -level 80 -color blue -verbose -whatif

Turns a device on with colors and level in whatif mode to see json without sending
```

## PARAMETERS

### -Command

Type of command to issue to device - Options: 'list', 'status', 'turnon', 'turnoff'

```yaml
Type:
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default Value: 'list'

```

### -Level

Set the bulb to the specified brightness level. (the device must support the "Switch Level" capabilities for this to work)

```yaml
Type: int
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default Value:

```

### -Color

Color to set on supported devices - Options: 'white', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'red' (the device must support the "Color Control" capabilities for this to work)

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default Value:

```

### -URI

API URI - Default: https://api.smartthings.com/v1

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default Value: 'https://api.smartthings.com/v1'

```

### -Token

Access tokens function like ordinary OAuth access tokens. They can be used instead of a password for Git over HTTPS, or can be use to authenticate to the API over Basic Authentication

```yaml
Type: string
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default Value: $env:SMARTTHINGS_CLI_TOKEN

```

### -DeviceName

Label or Name of device

```yaml
Type: string[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default Value:

```

### CommonParameters

## INPUTS

## OUTPUTS

PSCustomObject

## NOTES

This script was derived from GitHub: SmartThingsCommunity/cli-example-nodejs.

## RELATED LINKS

- <https://github.com/SmartThingsCommunity/cli-example-nodejs/blob/master/cli.js>
- <https://account.smartthings.com/tokens/new>
- <https://smartthings.developer.samsung.com/develop/api-ref/st-api.html>

