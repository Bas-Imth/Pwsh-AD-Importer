clear-host
Import-Module ActiveDirectory
function Import{  $users = Import-Csv -Path "*.csv" -Delimiter ';'

  ForEach ($user in $users) {
    $fullname = $user.firstname + " " + $user.lastname #AD Understands spaces.
    Write-Host  $fullname
    $username = $user.lastname + $user.firstname
    Write-Host $username
    $firstname = $user.firstname
    Write-Host $firstname
    $password = $user.password
    #$setpassword = ConvertTo-SecureString $password -AsPlainText -Force # I'm confident this doesn't work.
    $OU = $user.ou # This my not always work depending on your .csv file.
    Echo $OU  # Have to be sure it finds something.
    New-ADUser -Name $fullname -DisplayName $username -GivenName $firstname -Surname $lastname -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Path $OU
    Add-ADGroupMember -Identity $user.group1 -Members $fullname #Pwsh can't find users based on their username. Idk why.
  } }
do {
    do {
      Echo "Script made by: Bas Imth."
      Echo "This script will import users into AD from a .csv file"
      Echo "-----------------------------------------------------"
      Echo "A - Find file in current directory"
      Echo "B - Find file in directory of my choice"
      Echo "C - I've no clue, find it yourself - WARNING: HIGH FAIL CHANCE"
      Echo "X - Exit"
      Write-Host -nonewline "Your choice?:"

      $choice = Read-Host
      Write-Host ""

      $ok = $choice -match '^[abcx]+$'

      if ( -not $ok) { write-host "Not a valid option."} }until ( $ok )
      Clear-Host

      switch -Regex ( $choice ) {
      "A"
      {
        Write-Host "Searching script directory"
        Push-Location $folder
        Import
      }
      "B"
      {
        Write-host -nonewline "Which directory should I look in?:"
        $location = Read-Host -Prompt 'Input the directory to search in'
        Set-Location $location
        Import
    }
    "C"
    {
      Write-Host "This should go wrong."
      Get-Childitem ".\*.csv" –Path C:\ -Recurse –force -ErrorAction SilentlyContinue
      Import
    }
    "X"
    {
      Exit
    }
  }
}  until ( $choice -match "X" )
