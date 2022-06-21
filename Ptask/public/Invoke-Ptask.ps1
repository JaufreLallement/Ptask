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
      Mandatory = $true,
      ValueFromPipeline = $false,
      ValueFromPipelineByPropertyName = $false
    )]
    [ValidateNotNullOrEmpty()]
    [scriptblock]  $Action,

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

    $taskDynamicParams = @{}
    if ($Description) { $taskDynamicParams | add-member -MemberType NoteProperty -Name 'Description' -Value $Description }
    if ($User) { $taskDynamicParams | add-member -MemberType NoteProperty -Name 'User' -Value $User }

  }

  PROCESS {
    $taskTrigger = New-ScheduledTaskTrigger -Daily -At $Time
    $taskAction = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument ('-noprofile -command ' + $Action)
    Register-ScheduledTask -Action $taskAction -Trigger $taskTrigger -TaskName $TaskName @taskDynamicParams
  }

  END {
    Write-Host "Task registered !" -f Green
  }
}