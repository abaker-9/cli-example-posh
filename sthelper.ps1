<#
.SYNOPSIS
Get status and control SmartThings connected switches

.DESCRIPTION
The sthelper.ps1 script is a CLI implementation that uses REST to get devices and their status, and control SmartThings connected switches. This script was made possible thanks to the [node.js version](https://github.com/SmartThingsCommunity/cli-example-nodejs/) created by the SmartThings Community.

.PARAMETER Command
Type of command to issue to device - Options: 'list', 'status', 'turnon', 'turnoff'

.PARAMETER Level
Set the bulb to the specified brightness level. (the device must support the "Switch Level" capabilities for this to work)

.PARAMETER Color
Color to set on supported devices - Options: 'white', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'red' (the device must support the "Color Control" capabilities for this to work)

.PARAMETER URI
API URI - Default: https://api.smartthings.com/v1

.PARAMETER Token
Access tokens function like ordinary OAuth access tokens. They can be used instead of a password for Git over HTTPS, or can be use to authenticate to the API over Basic Authentication

.PARAMETER DeviceName
Label or Name of device

.EXAMPLE
.\sthelper.ps1 list

Lists all devices
.EXAMPLE
.\sthelper.ps1 list Breakfast

Lists a specific device
.EXAMPLE
.\sthelper.ps1 status Breakfast

Shows status of single device
.EXAMPLE
.\sthelper.ps1 status

Shows status of all devices
.EXAMPLE
.\sthelper.ps1 status Breakfast 'Rachio Sprinkler Controller' -verbose

Shows status of multiple devices
.EXAMPLE
.\sthelper turnon Breakfast

Turns a device on
.EXAMPLE
.\sthelper turnoff Breakfast

Turns a device off
.EXAMPLE
.\sthelper turnon Breakfast -level 80 -color blue -verbose -whatif

Turns a device on with colors and level in whatif mode to see json without sending
.NOTES
This script was derived from GitHub: SmartThingsCommunity/cli-example-nodejs.

.LINK
https://github.com/SmartThingsCommunity/cli-example-nodejs/blob/master/cli.js

.LINK
https://account.smartthings.com/tokens/new

.LINK
https://smartthings.developer.samsung.com/develop/api-ref/st-api.html

#>
[cmdletbinding(SupportsShouldProcess = $true)]
[OutputType([PSCustomObject])]
param(
  [parameter(Position = 0)]
  [ValidateSet('list', 'status', 'turnon', 'turnoff')]
  $Command = 'list',
  [int]$Level,
  [validateset('white', 'blue', 'green', 'yellow', 'orange', 'purple', 'pink', 'red')]
  [string]$Color,
  [string]$URI = 'https://api.smartthings.com/v1',
  [string]$Token = $env:SMARTTHINGS_CLI_TOKEN,
  [parameter(ValueFromRemainingArguments = $true)]
  [string[]]$DeviceName
)

Set-StrictMode -Version 1.0
$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
$vp = $VerbosePreference

if (-not $Token) {
  write-error "Please set `$env:SMARTTHINGS_CLI_TOKEN or pass 'Token parameter"
}

$headers = @{
  Authorization = "Bearer $Token"
}

$devices = Invoke-RestMethod -Uri "$URI/devices" -Headers $headers -UseBasicParsing

Function Get-DeviceStatus {
  param(
    $DeviceID,
    $DeviceName
  )
  $URL = "$URI/devices/$DeviceID/status"
  $data = Invoke-RestMethod -Uri $URL -Headers $headers -UseBasicParsing

  #Make the output object look nice. Original payload found under 'components' property
  $data | Add-Member -MemberType NoteProperty -Name DeviceName -Value $DeviceName
  $data | Add-Member -MemberType NoteProperty -Name DeviceID -Value $DeviceID
  $data | Add-Member -MemberType NoteProperty -Name SwitchStatus -Value $data.components.main.switch.switch.value
  $defaultProperties = @('DeviceName', 'DeviceID', 'SwitchStatus', 'components')
  $defaultDisplayPropertySet = New-Object System.Management.Automation.PSPropertySet('DefaultDisplayPropertySet', [string[]]$defaultProperties)
  $PSStandardMembers = [System.Management.Automation.PSMemberInfo[]]@($defaultDisplayPropertySet)
  $data | Add-Member MemberSet PSStandardMembers $PSStandardMembers
  write-output $data
}

Function Get-Color {
  [cmdletbinding()]
  param(
    [parameter(Mandatory)]
    $colorString
  )
  $hue = 0
  $saturation = 100
  switch ($colorString) {
    blue {
      $hue = 70
    }
    red {
      $hue = 10
    }
    purple {
      $hue = 75
    }
    white {
      $hue = 79
      saturation = 7
    }
    green {
      $hue = 39
    }
    yellow {
      $hue = 25
    }
    orange {
      $hue = 10
    }
    pink {
      $hue = 83
    }
    Default {
      # default is white
      write-warning "Color $colorString not supported. Supported colors are white, blue, green, yellow, orange, purple, pink, and red. Setting color to white."
      $hue = 79
      $saturation = 7
    }
  }

  write-output @{
    hue        = $hue
    saturation = $saturation
  }
}
Function Invoke-Actuate {
  [cmdletbinding()]
  param(
    $SwitchID,
    $Commands
  )
  $URL = "$URI/devices/$SwitchID/commands"
  $body = @($Commands)|convertto-json -Compress -Depth 10

  # convertto-json doesn't make an array if there is only one element
  if ($body -notmatch '^\[.*]$') {
    $body = "[$($body)]"
  }
  write-verbose "body: $($body|out-string)"

  Invoke-RestMethod -Uri $URL -Headers $headers -UseBasicParsing -Body $body -Method Post
}

$commands = @()

if ($PSBoundParameters['Command'] -match 'turn') {
  $commands += @{
    command    = ($PSBoundParameters['Command'] -replace 'turn', '')
    capability = 'switch'
    component  = 'main'
    arguments  = @()
  }
}

if ($PSBoundParameters['Level']) {
  $commands += @{
    command    = 'setLevel'
    capability = 'switchLevel'
    component  = 'main'
    arguments  = @($Level)
  }
}

if ($PSBoundParameters['Color']) {
  $commands += @{
    command    = 'setColor'
    capability = 'colorControl'
    component  = 'main'
    arguments  = @(Get-Color $Color)
  }
}

#match label or name
if ($DeviceName) {
  $deviceMapping = $devices.items|Where-Object {($_.label -in $DeviceName) -or ($_.name -in $DeviceName) }
} else {
  $deviceMapping = $devices.items
}

$deviceMapping = $deviceMapping|Select-Object deviceID, @{n = 'DeviceName'; e = {if ($_.label) {
      $_.label
    } else {
      $_.name
    }}
}

switch ($Command) {
  list {
    if ($DeviceName) {
      $devices|Select-Object -exp items|Where-Object {($_.label -in $DeviceName) -or ($_.name -in $DeviceName) }
    } else {
      $devices.items
    }
  }
  status {
    foreach ($device in $deviceMapping) {
      Get-DeviceStatus  -DeviceName $device.deviceName -DeviceID $device.deviceId
    }
  }
  {$_ -in 'turnon', 'turnoff'} {
    foreach ($device in $deviceMapping) {
      if ($pscmdlet.ShouldProcess("$($device.DeviceName) ($($device.deviceId))", $Command)) {
        Invoke-Actuate -SwitchID $device.deviceId -Commands $commands -Verbose:$vp
      } else {
        @($commands)|convertto-json -Depth 10
      }
    }
  }
}
