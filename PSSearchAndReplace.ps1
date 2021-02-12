<#

PSSearchAndReplace.ps1
2021-02-09, Alexander Eriksson, AER

A Search and Replace tool for Zip-archives, Folders or Single Files

#>

Param (
    [String]$List = "dictionary.csv",
    [String]$ExtList = "extensions.csv"
)
$Filenum = 0

Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory

    if ($script:Type -eq "zip")
    {
        $OpenFileDialog.filter = "ZIP (*.zip)| *.zip"
    }
    elseif ($script:Type -eq "folder")
    {
        $OpenFolderDialog = New-Object System.Windows.Forms.FolderBrowserDialog
        $OpenFolderDialog.SelectedPath = $initialDirectory
        $OpenFolderDialog.ShowDialog() | Out-Null
        $OpenFolderDialog.SelectedPath
    }
    elseif ($script:Type -eq "singlefile")
    {
        $OpenFileDialog.filter = "*.* (*.*)| *.*"
    }
    Else
    {
        #$OpenFileDialog.filter = "TEXT (*.txt)| *.txt"
        exit
    }

    if ($script:Type -ne "folder")
    {
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filename
    }
}

Function SearchAndReplace()
{
Write-Host("******************")
Get-ChildItem $Files -Recurse -include $Extensions |
ForEach-Object {
    $Content = Get-Content -Path $_.FullName;
    echo "Handling file: $($_.Name)"

    foreach ($ReplacementItem in $ReplacementList)
    {
        #$Content = $Content.Replace($ReplacementItem.OldValue, $ReplacementItem.NewValue)
        $Content = $Content -replace $ReplacementItem.OldValue, $ReplacementItem.NewValue
    }
    Set-Content -Path $_.FullName -Value $Content
}
Write-Host("******************")
echo "`nSearch and replace is complete!`n"
}


Function DialogueBox($BoxText)
{
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form
$form.Text = 'DialogueBox'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'

$OkButton = New-Object System.Windows.Forms.Button
$OkButton.Location = New-Object System.Drawing.Point(75,120)
$OkButton.Size = New-Object System.Drawing.Size(75,23)
$OkButton.Text = 'Ok'
$OkButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OkButton
$form.Controls.Add($OkButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,50)
$label.Text = $BoxText
$form.Controls.Add($label)
$form.Topmost = $true
$result = $form.ShowDialog()
}

Function DialogueBoxCancel($BoxText)
{
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form
$form.Text = 'DialogueBox'
$form.Size = New-Object System.Drawing.Size(475,200)
$form.StartPosition = 'CenterScreen'

$OkButton = New-Object System.Windows.Forms.Button
$OkButton.Location = New-Object System.Drawing.Point(162,120)
$OkButton.Size = New-Object System.Drawing.Size(75,23)
$OkButton.Text = 'Ok'
$OkButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $OkButton
$form.Controls.Add($OkButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(237,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(475,50)
$label.Text = $BoxText
$form.Controls.Add($label)
$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::Cancel)
{
exit
}

}

Function Form()
{
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Choose inputmethod'
$form.Size = New-Object System.Drawing.Size(475,200)
$form.StartPosition = 'CenterScreen'

$ZIPButton = New-Object System.Windows.Forms.Button
$ZIPButton.Location = New-Object System.Drawing.Point(75,120)
$ZIPButton.Size = New-Object System.Drawing.Size(75,23)
$ZIPButton.Text = 'ZIP'
$ZIPButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $ZIPButton
$form.Controls.Add($ZIPButton)

$FolderButton = New-Object System.Windows.Forms.Button
#$FolderButton.Enabled = 0
$FolderButton.Location = New-Object System.Drawing.Point(150,120)
$FolderButton.Size = New-Object System.Drawing.Size(75,23)
$FolderButton.Text = 'Folder'
$FolderButton.DialogResult = [System.Windows.Forms.DialogResult]::No
$form.CancelButton = $FolderButton
$form.Controls.Add($FolderButton)

$FileButton = New-Object System.Windows.Forms.Button
#$FileButton.Enabled = 0
$FileButton.Location = New-Object System.Drawing.Point(225,120)
$FileButton.Size = New-Object System.Drawing.Size(75,23)
$FileButton.Text = 'Single File'
$FileButton.DialogResult = [System.Windows.Forms.DialogResult]::Yes
$form.CancelButton = $FileButton
$form.Controls.Add($FileButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Point(300,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = 'Cancel'
$CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $CancelButton
$form.Controls.Add($CancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,50)
$label.Text = "Choose which type of input the script should handle:"
$form.Controls.Add($label)
$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
Write-Host = "ZIP"
$script:Type = "zip"
}

elseif ($result -eq [System.Windows.Forms.DialogResult]::No)
{
Write-Host = "Folder"
$script:Type = "folder"
}

elseif ($result -eq [System.Windows.Forms.DialogResult]::Yes)
{
Write-Host = "Single File"
$script:Type = "singlefile"
}

Else
{
Write-Host = "Ignore"
exit
}
}


## MAIN ##
#Dialoguebox for picking a type
Form

#Dialoguebox for picking file
$inputfile = Get-FileName $pwd.Path


#Get filename/foldername
$FolderPath = $inputfile
Get-ChildItem $inputfile | % {
if ($Type -ne "folder")
{
$FilePath = $_.FullName
$FileName = $_.Name
}
elseif ($Type -eq "folder")
{
$Folder = (Get-Item $inputfile)
$FolderName = $Folder.Name
$ParentFolder = $Folder.Parent.FullName
}
}


#Create destinationpath
if ($Type -eq "zip")
{
$DestinationFilePath = "$($pwd.Path)\Scrubbed_$($FileName)"
$PathCheck = Test-Path -Path $DestinationFilePath -PathType Leaf
while ($PathCheck -eq $true)
{
$Filenum++
$DestinationFilePath = "$($pwd.Path)\Scrubbed($($Filenum))_$($FileName)"
$PathCheck = Test-Path -Path $DestinationFilePath -PathType Leaf
}
}
elseif ($Type -eq "folder")
{
$DestinationFilePath = "$($ParentFolder)\Scrubbed_$($FolderName)"
$PathCheck = Test-Path -Path $DestinationFilePath -PathType Container
while ($PathCheck -eq $true)
{
$Filenum++
$DestinationFilePath = "$($ParentFolder)\Scrubbed_$($FolderName)($($Filenum))"
$PathCheck = Test-Path -Path $DestinationFilePath -PathType Container
}
}
elseif ($Type -eq "singlefile")
{
$Files = ".\srubbedfile\"
#$DataFolderName = Resolve-Path $Files
$DataFolderName = $Files
$PathCheck = Test-Path -Path $DataFolderName -PathType Container
if ($PathCheck -eq $true)
{
echo "Folder $($DataFolderName) already exists"
}
Else
{
New-Item -Path $Files -ItemType Directory | Out-Null
}
$DataFolderName = Resolve-Path $Files
$DestinationFilePath = "$($DataFolderName)$($FileName)"
$DestinationFileName = "$($FileName)"
$PathCheck = Test-Path -Path $DestinationFilePath
while ($PathCheck -eq $true)
{
$Filenum++
$DestinationFilePath = "$($DataFolderName)($($Filenum))$($FileName)"
$DestinationFileName = "($($Filenum))$($FileName)"
$PathCheck = Test-Path -Path $DestinationFilePath
}
}


# Continuedialogue
DialogueBoxCancel "This script will be creating a new scrubbed $($Type):`n$($DestinationFilePath)`n`nOriginal file will be kept. Continue?"

if ($Type -eq "zip")
{
$Files = ".\temp\"
# Creating temporary datafolder
New-Item -Path $Files -ItemType Directory | Out-Null
$DataFolderName = Resolve-Path $Files

# Unzips file
echo "`nExtracting archive..."
echo $FilePath
Expand-Archive -Path $FilePath -DestinationPath $DataFolderName
}

if ($Type -eq "folder")
{
# Creating destinationfolder and copies the folder
New-Item -Path $DestinationFilePath -ItemType Directory | Out-Null
$DataFolderName = Resolve-Path $DestinationFilePath
Copy-Item -Path $FolderPath -Recurse -Destination $DestinationFilePath -Container
$Files = $DestinationFilePath
}

if ($Type -eq "singlefile")
{
#Copies the inputfile
Copy-Item -Path $FilePath -Destination $DestinationFilePath
}

# Reads csv-files and sets filter
$ReplacementList = Import-Csv $List;
$Extensions=@()
if ($Type -ne "singlefile")
{
Import-Csv $ExtList | ForEach-Object { $Extensions += $_.Extensions }
}
Else
{
$Extensions += $DestinationFileName
}


# Replace loop
echo "`nSearches and replaces in files using filter:"
$Extensions
SearchAndReplace

# Zipping scrubbed files
if ($Type -eq "zip")
{
echo "Creating archive: $($DestinationFilePath)"
Compress-Archive -Path $DataFolderName -DestinationPath $DestinationFilePath

# Deleting data-folder
echo "`nCleaning files..."
Remove-Item $DataFolderName -Recurse
}

#Complete
if ($Type -eq "singlefile")
{
DialogueBox "Completed...`nScrubbed file created:`n$($DataFolderName)$($DestinationFileName)"
}
Else
{
DialogueBox "Completed...`nScrubbed $($Type) created:`n$($DestinationFilePath)"
}