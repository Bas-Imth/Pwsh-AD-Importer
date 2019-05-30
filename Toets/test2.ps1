Clear-Host
Import-Module ActiveDirectory
  $users = Import-Csv -Path 'D:\*.csv' -Delimiter ','


  ForEach ($user in $users) {
    $fullname = $user.Firstname + " " + $user.Lastname #AD Understands spaces!
    $username = $user.Lastname + $user.Firstname #I like making usernames Surname + Firstname.
    $firstname = $user.Firstname
    $password = $user.Password
    $homedirectory ='D:\Users\' -f $username
    $OU = $user.ou +"," + " " + "DC=thomson, DC=eu" # That ugly comma you see there was neccessary to get the .csv's OU path to work.
    Write-Host $OU #I like OU feedback for testing.
    New-ADUser -Name "$fullname" -DisplayName "$username" -GivenName "$firstname" -Surname "$lastname" -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -Enabled $true -Path $OU
    Add-ADGroupMember -Identity "SG_IMPORT" -Members "$fullname" #Pwsh can't find users using their username, and thus needs their full name. Idk why.
    Set-ADUser "$fullname" -homedirectory "$homedirectory" -homedrive d; 
    if( -not ( Test-Path $homedirectory) ){
      New-Item -Path $homedirectory -ItemType directory
    }
  }
