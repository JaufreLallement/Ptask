function Invoke-Ptask {
  <#
  .SYNOPSIS
    This script will register a new schedule task

  .NOTES
    Name: Invoke-Ptask
    Author: JL
    Version: 1.0
    LastUpdated: 2022-Jun-15

  .EXAMPLE

  #>

  [CmdletBinding()]
  param(
    [Parameter(
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $TaskName,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $Description,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [scriptblock]  $ActionCommand,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [scriptblock]  $ActionFile,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [datetime]  $Time = '9am',

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $Recurence,

    [Parameter(
      Mandatory = $false,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [string]  $User
  )

  BEGIN {
    Write-Host $banner -f Green
    Write-Host "Registering new task..." -f Yellow

    $actionMode = "-command"
    $actionParam = $null

    if (!$ActionCommand && !$ActionFile) {
      throw "A file or command must be specified !"
    }
    elseif ($ActionCommand && $ActionFile) {
      throw "Expected an action command or file, but both were specified !"
    }
    elseif ($ActionCommand) {
      $actionParam = $ActionCommand
    }
    else {
      if (!(Test-Path $ActionFile)) {
        throw "The provided path $ActionFile is not valid !"
      }
      $actionMode = "-file"
      $ActionCommand = $ActionFile
    }

    $taskDynamicParams = @{}
    if ($Description) { $taskDynamicParams | add-member -MemberType NoteProperty -Name 'Description' -Value $Description }
    if ($User) { $taskDynamicParams | add-member -MemberType NoteProperty -Name 'User' -Value $User }

  }

  PROCESS {
    $taskTrigger = New-ScheduledTaskTrigger -Daily -At $Time
    $taskAction = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument ("-noprofile $actionMode " + $actionParam)
    Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName $TaskName @taskDynamicParams
  }

  END {
    Write-Host "Task registered !" -f Green
  }
}