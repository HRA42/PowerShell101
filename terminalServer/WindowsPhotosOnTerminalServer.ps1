<#
    Author:     Henry Rausch
    GitHub:     https://GitHub.com/HRA42
    Date:       01.04.2024
    Version:    1.0
    .Synopsis
        This script activates the photo viewer on a windows terminal server
#>

# If the folder C:\TEMP does not exist, it must be created
$tempFolder = "C:\tmp\"
If (!(Test-Path $tempFolder)) {
    Write-Output "The folder $tempFolder does not exist. It will be created."
    New-Item -ItemType Directory -Path $tempFolder
}

$currentScript = ($MyInvocation.MyCommand.Name) -replace ".ps1", ""
Start-Transcript "$tempFolder\$(Split-Path -Leaf $currentScript).log"

<#
----------------------------------
Definition of variables
----------------------------------
#>
# Define needed RegKeys here
jpeRegfile = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\.jpe]

[HKEY_CLASSES_ROOT\.jpe]
"Content Type"="image/jpeg"
@="jpegfile"
"PerceivedType"="image"

[HKEY_CLASSES_ROOT\.jpe\OpenWithProgids]
"jpegfile"=""

[HKEY_CLASSES_ROOT\.jpe\PersistentHandler]
@="{098f2470-bae0-11cd-b579-08002b30bfeb}"

[-HKEY_CLASSES_ROOT\jpegfile]

[HKEY_CLASSES_ROOT\jpegfile]
@="JPEG Image"
"EditFlags"=dword:00010000
"FriendlyTypeName"=hex(2):40,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,\
    00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,\
    32,00,5c,00,73,00,68,00,65,00,6c,00,6c,00,33,00,32,00,2e,00,64,00,6c,00,6c,\
    00,2c,00,2d,00,33,00,30,00,35,00,39,00,36,00,00,00
"ImageOptionFlags"=dword:00000001

[HKEY_CLASSES_ROOT\jpegfile\CLSID]
@="{25336920-03F9-11cf-8FD0-00AA00686F13}"

[HKEY_CLASSES_ROOT\jpegfile\DefaultIcon]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,69,00,6d,00,\
    61,00,67,00,65,00,72,00,65,00,73,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,37,\
    00,32,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell]

[HKEY_CLASSES_ROOT\jpegfile\shell\open]
"MuiVerb"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,\
    69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,\
    00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,\
    72,00,5c,00,70,00,68,00,6f,00,74,00,6f,00,76,00,69,00,65,00,77,00,65,00,72,\
    00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,34,00,33,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell\open\command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\
    6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\
    00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\
    25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\
    00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\
    6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\
    00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\
    5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\
    00,31,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell\open\DropTarget]
"Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

[HKEY_CLASSES_ROOT\jpegfile\shell\printto]

[HKEY_CLASSES_ROOT\jpegfile\shell\printto\command]
@=hex(2):22,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
    00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,\
    75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,22,00,20,\
    00,22,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,\
    25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,73,00,68,\
    00,69,00,6d,00,67,00,76,00,77,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,49,00,\
    6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,50,00,72,00,69,00,6e,\
    00,74,00,54,00,6f,00,20,00,2f,00,70,00,74,00,20,00,22,00,25,00,31,00,22,00,\
    20,00,22,00,25,00,32,00,22,00,20,00,22,00,25,00,33,00,22,00,20,00,22,00,25,\
    00,34,00,22,00,00,00

[-HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe]
"PreviewDetails"="prop:System.Photo.DateTaken;System.Keywords;*System.Photo.PeopleNames;System.Rating;*System.Image.Dimensions;*System.Size;System.Title;System.Author;System.Comment;*System.OfflineAvailability;*System.OfflineStatus;System.Photo.CameraManufacturer;System.Photo.CameraModel;System.Subject;*System.Photo.FNumber;*System.Photo.ExposureTime;*System.Photo.ISOSpeed;*System.Photo.ExposureBias;*System.Photo.FocalLength;*System.Photo.MaxAperture;*System.Photo.MeteringMode;*System.Photo.SubjectDistance;*System.Photo.Flash;*System.Photo.FlashEnergy;*System.Photo.FocalLengthInFilm;*System.DateCreated;*System.DateModified;*System.SharedWith"
"FullDetails"="prop:System.PropGroup.Description;System.Title;System.Subject;System.Rating;System.Keywords;*System.Photo.PeopleNames;System.Comment;System.PropGroup.Origin;System.Author;System.Photo.DateTaken;System.ApplicationName;System.DateAcquired;System.Copyright;System.PropGroup.Image;System.Image.ImageID;System.Image.Dimensions;System.Image.HorizontalSize;System.Image.VerticalSize;System.Image.HorizontalResolution;System.Image.VerticalResolution;System.Image.BitDepth;System.Image.Compression;System.Image.ResolutionUnit;System.Image.ColorSpace;System.Image.CompressedBitsPerPixel;System.PropGroup.Camera;System.Photo.CameraManufacturer;System.Photo.CameraModel;System.Photo.FNumber;System.Photo.ExposureTime;System.Photo.ISOSpeed;System.Photo.ExposureBias;System.Photo.FocalLength;System.Photo.MaxAperture;System.Photo.MeteringMode;System.Photo.SubjectDistance;System.Photo.Flash;System.Photo.FlashEnergy;System.Photo.FocalLengthInFilm;System.PropGroup.PhotoAdvanced;System.Photo.LensManufacturer;System.Photo.LensModel;System.Photo.FlashManufacturer;System.Photo.FlashModel;System.Photo.CameraSerialNumber;System.Photo.Contrast;System.Photo.Brightness;System.Photo.LightSource;System.Photo.ExposureProgram;System.Photo.Saturation;System.Photo.Sharpness;System.Photo.WhiteBalance;System.Photo.PhotometricInterpretation;System.Photo.DigitalZoom;System.Photo.EXIFVersion;System.PropGroup.GPS;*System.GPS.Latitude;*System.GPS.Longitude;*System.GPS.Altitude;System.PropGroup.FileSystem;System.ItemNameDisplay;System.ItemType;System.ItemFolderPathDisplay;System.DateCreated;System.DateModified;System.Size;System.FileAttributes;System.OfflineAvailability;System.OfflineStatus;System.SharedWith;System.FileOwner;System.ComputerName"
"InfoTip"="prop:System.ItemType;System.Photo.DateTaken;System.Keywords;*System.Photo.PeopleNames;System.Rating;*System.Image.Dimensions;*System.Size;System.Title"
"ExtendedTileInfo"="prop:System.ItemType;System.Photo.DateTaken;*System.Image.Dimensions"
"SetDefaultsFor"="prop:System.Author;System.Document.DateCreated;System.Photo.DateTaken"
"ImageOptionFlags"=dword:00000001

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\OpenWithList]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\OpenWithList\PhotoViewer.dll]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\Shell]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\Shell\setdesktopwallpaper]
"MultiSelectModel"="Player"
@=hex(2):40,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
    00,25,00,5c,00,73,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,73,00,\
    74,00,6f,00,62,00,6a,00,65,00,63,00,74,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,\
    00,34,00,31,00,37,00,00,00
"NeverDefault"=""
"SuppressionSlapiPolicy"="ChangeDesktopBackground-Enabled"

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\Shell\setdesktopwallpaper\Command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,45,00,78,00,70,00,6c,00,6f,00,72,00,65,00,72,00,2e,00,65,00,78,00,\
    65,00,00,00
"DelegateExecute"="{ff609cc7-d34d-4049-a1aa-2293517ffcc6}"

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\ShellEx]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpe\ShellEx\ContextMenuHandlers\ShellImagePreview]
@="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe]

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe]

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithProgids]
"jpegfile"=hex(0):
"@

$jpegRegfile = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\.jpeg]

[HKEY_CLASSES_ROOT\.jpeg]
"Content Type"="image/jpeg"
@="jpegfile"
"PerceivedType"="image"

[HKEY_CLASSES_ROOT\.jpeg\OpenWithList]

[HKEY_CLASSES_ROOT\.jpeg\OpenWithList\ehshell.exe]

[HKEY_CLASSES_ROOT\.jpeg\OpenWithProgids]
"jpegfile"=""

[HKEY_CLASSES_ROOT\.jpeg\PersistentHandler]
@="{098f2470-bae0-11cd-b579-08002b30bfeb}"

[-HKEY_CLASSES_ROOT\jpegfile]

[HKEY_CLASSES_ROOT\jpegfile]
@="JPEG Image"
"EditFlags"=dword:00010000
"FriendlyTypeName"=hex(2):40,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,\
    00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,\
    32,00,5c,00,73,00,68,00,65,00,6c,00,6c,00,33,00,32,00,2e,00,64,00,6c,00,6c,\
    00,2c,00,2d,00,33,00,30,00,35,00,39,00,36,00,00,00
"ImageOptionFlags"=dword:00000001

[HKEY_CLASSES_ROOT\jpegfile\CLSID]
@="{25336920-03F9-11cf-8FD0-00AA00686F13}"

[HKEY_CLASSES_ROOT\jpegfile\DefaultIcon]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,69,00,6d,00,\
    61,00,67,00,65,00,72,00,65,00,73,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,37,\
    00,32,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell]

[HKEY_CLASSES_ROOT\jpegfile\shell\open]
"MuiVerb"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,\
    69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,\
    00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,\
    72,00,5c,00,70,00,68,00,6f,00,74,00,6f,00,76,00,69,00,65,00,77,00,65,00,72,\
    00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,34,00,33,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell\open\command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\
    6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\
    00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\
    25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\
    00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\
    6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\
    00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\
    5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\
    00,31,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell\open\DropTarget]
"Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

[HKEY_CLASSES_ROOT\jpegfile\shell\printto]

[HKEY_CLASSES_ROOT\jpegfile\shell\printto\command]
@=hex(2):22,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
    00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,\
    75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,22,00,20,\
    00,22,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,\
    25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,73,00,68,\
    00,69,00,6d,00,67,00,76,00,77,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,49,00,\
    6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,50,00,72,00,69,00,6e,\
    00,74,00,54,00,6f,00,20,00,2f,00,70,00,74,00,20,00,22,00,25,00,31,00,22,00,\
    20,00,22,00,25,00,32,00,22,00,20,00,22,00,25,00,33,00,22,00,20,00,22,00,25,\
    00,34,00,22,00,00,00

[-HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg]
"PreviewDetails"="prop:System.Photo.DateTaken;System.Keywords;*System.Photo.PeopleNames;System.Rating;*System.Image.Dimensions;*System.Size;System.Title;System.Author;System.Comment;*System.OfflineAvailability;*System.OfflineStatus;System.Photo.CameraManufacturer;System.Photo.CameraModel;System.Subject;*System.Photo.FNumber;*System.Photo.ExposureTime;*System.Photo.ISOSpeed;*System.Photo.ExposureBias;*System.Photo.FocalLength;*System.Photo.MaxAperture;*System.Photo.MeteringMode;*System.Photo.SubjectDistance;*System.Photo.Flash;*System.Photo.FlashEnergy;*System.Photo.FocalLengthInFilm;*System.DateCreated;*System.DateModified;*System.SharedWith"
"FullDetails"="prop:System.PropGroup.Description;System.Title;System.Subject;System.Rating;System.Keywords;*System.Photo.PeopleNames;System.Comment;System.PropGroup.Origin;System.Author;System.Photo.DateTaken;System.ApplicationName;System.DateAcquired;System.Copyright;System.PropGroup.Image;System.Image.ImageID;System.Image.Dimensions;System.Image.HorizontalSize;System.Image.VerticalSize;System.Image.HorizontalResolution;System.Image.VerticalResolution;System.Image.BitDepth;System.Image.Compression;System.Image.ResolutionUnit;System.Image.ColorSpace;System.Image.CompressedBitsPerPixel;System.PropGroup.Camera;System.Photo.CameraManufacturer;System.Photo.CameraModel;System.Photo.FNumber;System.Photo.ExposureTime;System.Photo.ISOSpeed;System.Photo.ExposureBias;System.Photo.FocalLength;System.Photo.MaxAperture;System.Photo.MeteringMode;System.Photo.SubjectDistance;System.Photo.Flash;System.Photo.FlashEnergy;System.Photo.FocalLengthInFilm;System.PropGroup.PhotoAdvanced;System.Photo.LensManufacturer;System.Photo.LensModel;System.Photo.FlashManufacturer;System.Photo.FlashModel;System.Photo.CameraSerialNumber;System.Photo.Contrast;System.Photo.Brightness;System.Photo.LightSource;System.Photo.ExposureProgram;System.Photo.Saturation;System.Photo.Sharpness;System.Photo.WhiteBalance;System.Photo.PhotometricInterpretation;System.Photo.DigitalZoom;System.Photo.EXIFVersion;System.PropGroup.GPS;*System.GPS.Latitude;*System.GPS.Longitude;*System.GPS.Altitude;System.PropGroup.FileSystem;System.ItemNameDisplay;System.ItemType;System.ItemFolderPathDisplay;System.DateCreated;System.DateModified;System.Size;System.FileAttributes;System.OfflineAvailability;System.OfflineStatus;System.SharedWith;System.FileOwner;System.ComputerName"
"InfoTip"="prop:System.ItemType;System.Photo.DateTaken;System.Keywords;*System.Photo.PeopleNames;System.Rating;*System.Image.Dimensions;*System.Size;System.Title"
"ExtendedTileInfo"="prop:System.ItemType;System.Photo.DateTaken;*System.Image.Dimensions"
"SetDefaultsFor"="prop:System.Author;System.Document.DateCreated;System.Photo.DateTaken"
"ImageOptionFlags"=dword:00000001

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\OpenWithList]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\OpenWithList\PhotoViewer.dll]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\Shell]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\Shell\setdesktopwallpaper]
"MultiSelectModel"="Player"
@=hex(2):40,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
    00,25,00,5c,00,73,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,73,00,\
    74,00,6f,00,62,00,6a,00,65,00,63,00,74,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,\
    00,34,00,31,00,37,00,00,00
"NeverDefault"=""
"SuppressionSlapiPolicy"="ChangeDesktopBackground-Enabled"

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\Shell\setdesktopwallpaper\Command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,45,00,78,00,70,00,6c,00,6f,00,72,00,65,00,72,00,2e,00,65,00,78,00,\
    65,00,00,00
"DelegateExecute"="{ff609cc7-d34d-4049-a1aa-2293517ffcc6}"

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\ShellEx]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpeg\ShellEx\ContextMenuHandlers\ShellImagePreview]
@="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg]

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg]

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithProgids]
"jpegfile"=hex(0):
"@

$jpgRegfile = @"
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\.jpg]

[HKEY_CLASSES_ROOT\.jpg]
"Content Type"="image/jpeg"
@="jpegfile"
"PerceivedType"="image"

[HKEY_CLASSES_ROOT\.jpg\OpenWithList]

[HKEY_CLASSES_ROOT\.jpg\OpenWithList\ehshell.exe]

[HKEY_CLASSES_ROOT\.jpg\OpenWithProgids]
"jpegfile"=""

[HKEY_CLASSES_ROOT\.jpg\PersistentHandler]
@="{098f2470-bae0-11cd-b579-08002b30bfeb}"

[-HKEY_CLASSES_ROOT\jpegfile]

[HKEY_CLASSES_ROOT\jpegfile]
@="JPEG Image"
"EditFlags"=dword:00010000
"FriendlyTypeName"=hex(2):40,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,\
    00,6f,00,6f,00,74,00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,\
    32,00,5c,00,73,00,68,00,65,00,6c,00,6c,00,33,00,32,00,2e,00,64,00,6c,00,6c,\
    00,2c,00,2d,00,33,00,30,00,35,00,39,00,36,00,00,00
"ImageOptionFlags"=dword:00000001

[HKEY_CLASSES_ROOT\jpegfile\CLSID]
@="{25336920-03F9-11cf-8FD0-00AA00686F13}"

[HKEY_CLASSES_ROOT\jpegfile\DefaultIcon]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,69,00,6d,00,\
    61,00,67,00,65,00,72,00,65,00,73,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,37,\
    00,32,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell]

[HKEY_CLASSES_ROOT\jpegfile\shell\open]
"MuiVerb"=hex(2):40,00,25,00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,\
    69,00,6c,00,65,00,73,00,25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,\
    00,20,00,50,00,68,00,6f,00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,\
    72,00,5c,00,70,00,68,00,6f,00,74,00,6f,00,76,00,69,00,65,00,77,00,65,00,72,\
    00,2e,00,64,00,6c,00,6c,00,2c,00,2d,00,33,00,30,00,34,00,33,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell\open\command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,75,00,\
    6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,20,00,22,00,25,\
    00,50,00,72,00,6f,00,67,00,72,00,61,00,6d,00,46,00,69,00,6c,00,65,00,73,00,\
    25,00,5c,00,57,00,69,00,6e,00,64,00,6f,00,77,00,73,00,20,00,50,00,68,00,6f,\
    00,74,00,6f,00,20,00,56,00,69,00,65,00,77,00,65,00,72,00,5c,00,50,00,68,00,\
    6f,00,74,00,6f,00,56,00,69,00,65,00,77,00,65,00,72,00,2e,00,64,00,6c,00,6c,\
    00,22,00,2c,00,20,00,49,00,6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,\
    5f,00,46,00,75,00,6c,00,6c,00,73,00,63,00,72,00,65,00,65,00,6e,00,20,00,25,\
    00,31,00,00,00

[HKEY_CLASSES_ROOT\jpegfile\shell\open\DropTarget]
"Clsid"="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

[HKEY_CLASSES_ROOT\jpegfile\shell\printto]

[HKEY_CLASSES_ROOT\jpegfile\shell\printto\command]
@=hex(2):22,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
    00,25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,72,00,\
    75,00,6e,00,64,00,6c,00,6c,00,33,00,32,00,2e,00,65,00,78,00,65,00,22,00,20,\
    00,22,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,\
    25,00,5c,00,53,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,73,00,68,\
    00,69,00,6d,00,67,00,76,00,77,00,2e,00,64,00,6c,00,6c,00,22,00,2c,00,49,00,\
    6d,00,61,00,67,00,65,00,56,00,69,00,65,00,77,00,5f,00,50,00,72,00,69,00,6e,\
    00,74,00,54,00,6f,00,20,00,2f,00,70,00,74,00,20,00,22,00,25,00,31,00,22,00,\
    20,00,22,00,25,00,32,00,22,00,20,00,22,00,25,00,33,00,22,00,20,00,22,00,25,\
    00,34,00,22,00,00,00

[-HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg]
"PreviewDetails"="prop:System.Photo.DateTaken;System.Keywords;*System.Photo.PeopleNames;System.Rating;*System.Image.Dimensions;*System.Size;System.Title;System.Author;System.Comment;*System.OfflineAvailability;*System.OfflineStatus;System.Photo.CameraManufacturer;System.Photo.CameraModel;System.Subject;*System.Photo.FNumber;*System.Photo.ExposureTime;*System.Photo.ISOSpeed;*System.Photo.ExposureBias;*System.Photo.FocalLength;*System.Photo.MaxAperture;*System.Photo.MeteringMode;*System.Photo.SubjectDistance;*System.Photo.Flash;*System.Photo.FlashEnergy;*System.Photo.FocalLengthInFilm;*System.DateCreated;*System.DateModified;*System.SharedWith"
"FullDetails"="prop:System.PropGroup.Description;System.Title;System.Subject;System.Rating;System.Keywords;*System.Photo.PeopleNames;System.Comment;System.PropGroup.Origin;System.Author;System.Photo.DateTaken;System.ApplicationName;System.DateAcquired;System.Copyright;System.PropGroup.Image;System.Image.ImageID;System.Image.Dimensions;System.Image.HorizontalSize;System.Image.VerticalSize;System.Image.HorizontalResolution;System.Image.VerticalResolution;System.Image.BitDepth;System.Image.Compression;System.Image.ResolutionUnit;System.Image.ColorSpace;System.Image.CompressedBitsPerPixel;System.PropGroup.Camera;System.Photo.CameraManufacturer;System.Photo.CameraModel;System.Photo.FNumber;System.Photo.ExposureTime;System.Photo.ISOSpeed;System.Photo.ExposureBias;System.Photo.FocalLength;System.Photo.MaxAperture;System.Photo.MeteringMode;System.Photo.SubjectDistance;System.Photo.Flash;System.Photo.FlashEnergy;System.Photo.FocalLengthInFilm;System.PropGroup.PhotoAdvanced;System.Photo.LensManufacturer;System.Photo.LensModel;System.Photo.FlashManufacturer;System.Photo.FlashModel;System.Photo.CameraSerialNumber;System.Photo.Contrast;System.Photo.Brightness;System.Photo.LightSource;System.Photo.ExposureProgram;System.Photo.Saturation;System.Photo.Sharpness;System.Photo.WhiteBalance;System.Photo.PhotometricInterpretation;System.Photo.DigitalZoom;System.Photo.EXIFVersion;System.PropGroup.GPS;*System.GPS.Latitude;*System.GPS.Longitude;*System.GPS.Altitude;System.PropGroup.FileSystem;System.ItemNameDisplay;System.ItemType;System.ItemFolderPathDisplay;System.DateCreated;System.DateModified;System.Size;System.FileAttributes;System.OfflineAvailability;System.OfflineStatus;System.SharedWith;System.FileOwner;System.ComputerName"
"InfoTip"="prop:System.ItemType;System.Photo.DateTaken;System.Keywords;*System.Photo.PeopleNames;System.Rating;*System.Image.Dimensions;*System.Size;System.Title"
"ExtendedTileInfo"="prop:System.ItemType;System.Photo.DateTaken;*System.Image.Dimensions"
"SetDefaultsFor"="prop:System.Author;System.Document.DateCreated;System.Photo.DateTaken"
"ImageOptionFlags"=dword:00000001

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\OpenWithList]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\OpenWithList\PhotoViewer.dll]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\Shell]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\Shell\setdesktopwallpaper]
"MultiSelectModel"="Player"
@=hex(2):40,00,25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,\
    00,25,00,5c,00,73,00,79,00,73,00,74,00,65,00,6d,00,33,00,32,00,5c,00,73,00,\
    74,00,6f,00,62,00,6a,00,65,00,63,00,74,00,2e,00,64,00,6c,00,6c,00,2c,00,2d,\
    00,34,00,31,00,37,00,00,00
"NeverDefault"=""
"SuppressionSlapiPolicy"="ChangeDesktopBackground-Enabled"

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\Shell\setdesktopwallpaper\Command]
@=hex(2):25,00,53,00,79,00,73,00,74,00,65,00,6d,00,52,00,6f,00,6f,00,74,00,25,\
    00,5c,00,45,00,78,00,70,00,6c,00,6f,00,72,00,65,00,72,00,2e,00,65,00,78,00,\
    65,00,00,00
"DelegateExecute"="{ff609cc7-d34d-4049-a1aa-2293517ffcc6}"

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\ShellEx]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers]

[HKEY_CLASSES_ROOT\SystemFileAssociations\.jpg\ShellEx\ContextMenuHandlers\ShellImagePreview]
@="{FFE2A43C-56B9-4bf5-9A79-CC6D4285608A}"

[-HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg]

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg]

[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithProgids]
"jpegfile"=hex(0):
"@

<#
----------------------------------
Definition of functions
----------------------------------
#>
# Create temp files for import into registry
function importRegFiles() {
    # Create Temp Reg Files for Import
    $jpeRegfile | Out-File -FilePath "C:\tmp\temp1.reg" -Encoding ASCII
    $jpegRegfile | Out-File -FilePath "C:\tmp\temp2.reg" -Encoding ASCII
    $jpgRegfile | Out-File -FilePath "C:\tmp\temp3.reg" -Encoding ASCII
    # Import Reg Files
    Start-Process -FilePath "regedit.exe" -ArgumentList "/s", "C:\tmp\temp1.reg" -Wait
    Start-Process -FilePath "regedit.exe" -ArgumentList "/s", "C:\tmp\temp2.reg" -Wait
    Start-Process -FilePath "regedit.exe" -ArgumentList "/s", "C:\tmp\temp3.reg" -Wait
    # Remove Temp Reg Files
    Remove-Item -Path "C:\tmp\temp1.reg"
    Remove-Item -Path "C:\tmp\temp2.reg"
    Remove-Item -Path "C:\tmp\temp3.reg"
    # Set the default program for opening images
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name PhotoViewer.FileAssoc.Tiff -Value .tif
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name PhotoViewer.FileAssoc.Tiff -Value .gif
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name PhotoViewer.FileAssoc.Tiff -Value .png
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Photo Viewer\Capabilities\FileAssociations" -Name PhotoViewer.FileAssoc.Tiff -Value .jpg
}

# Activate Windows Photo Viewer DDLs
function activatePhotoViewer() {
    Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s", '"C:\Program Files (x86)\Windows Photo Viewer\PhotoViewer.dll"' -Verb RunAs -Wait
    Start-Process -FilePath "regsvr32.exe" -ArgumentList "/s", '"C:\Program Files\Windows Photo Viewer\PhotoViewer.dll"' -Verb RunAs -Wait
}

<#
----------------------------------
Execution of functions
----------------------------------
#>
activatePhotoViewer
importRegFiles

Stop-Transcript
