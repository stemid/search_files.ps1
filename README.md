# search\_files.ps1

This is an adaptation of a simple script I wrote to search for files in Windows. The original is [here in this repo](https://github.com/stemid/devops/).

This fork is adapted for [AlphaFS](https://github.com/alphaleonis/AlphaFS/) which is an amazing little open source product that not only shows Microsoft how they ought to code their API, but also overcomes a number of issues I was having like 260-character limit for paths.

# Installation

  - First download the latest release of AlphaFS from [their github-releases page](https://github.com/alphaleonis/AlphaFS/releases). 
  - Create your scripts directory, like C:\scripts.
  - Go to your scripts directory and unpack AlphaFS there.
  - Clone or download contents of this git repo into your scripts directory.
  - Edit search\_files.ps1 and make sure the path on line 21 that starts ``Import-Module`` points to the correct AlphaFS file.
  - Run script

# Example of running script

    .\search_files.ps1 -SearchPath "\\server01\D$" -Recurse -Filter "*.encrypted"

## Parameters

  * -SearchPath PATH - Path to search, defaults to current working directory.
  * -OutputFile PATH - Output search results in CSV format.
  * -Recurse BOOL - Do a recursive search, defaults to false.
  * -Filter STRING - Search filter, defaults to wildcard.
  * -MoveTo PATH - Move any file found to this dir, defaults to false.

# Known issue

The DLL might become **blocked** for some reason, resulting in this error when you try to import-module. 

    PS C:\scripts> import-module -name "C:\scripts\AlphaFS.2.0.1\lib\net451\AlphaFS.dll"
    import-module : Could not load file or assembly 'file:///C:\scripts\AlphaFS.2.0.1\lib\net451\AlphaFS.dll' or one of its
     dependencies. Operation is not supported. (Exception from HRESULT: 0x80131515)
    At line:1 char:1
    + import-module -name "C:\scripts\AlphaFS.2.0.1\lib\net451\AlphaFS.dll"
    + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        + CategoryInfo          : NotSpecified: (:) [Import-Module], FileLoadException
        + FullyQualifiedErrorId : System.IO.FileLoadException,Microsoft.PowerShell.Commands.ImportModuleCommand

According to gurus on IRC you need to unblock the DLL, close Powershell and try again. 

  * `Unblock-File "C:\scripts\AlphaFS.2.0.1\lib\net451\AlphaFS.dll"`
  * `Exit`
  * Open new Powershell session
  * `Import-Module "C:\scripts\AlphaFS.2.0.1\lib\net451\AlphaFS.dll"`

# Disclaimer

[Get-AlphaFSChildItem.ps1](https://gallery.technet.microsoft.com/Get-AlphaFSChildItems-ff95f60f) is a product of some kind soul at TechNet. That function made it much easier for me to use AlphaFS since they had already figured out their API. As I write this it is licensed under the [MIT license](https://opensource.org/licenses/MIT).
