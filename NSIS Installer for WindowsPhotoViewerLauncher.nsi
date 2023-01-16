; WindowsPhotoViewerLauncher Installer NSIS Script
; get NSIS at http://nsis.sourceforge.net/Download

!define ProgramName "WindowsPhotoViewerLauncher"
!define ProgramVersion 1.0.0.0
Icon "Properties\WindowsPhotoViewerLauncher.ico"

Name "${ProgramName}"
Caption "${ProgramName} Installer"
XPStyle on
Unicode true
ShowInstDetails show
AutoCloseWindow true

VIProductVersion ${ProgramVersion}
VIAddVersionKey "ProductVersion" "${ProgramVersion}"
VIAddVersionKey "ProductName" "${ProgramName}"
VIAddVersionKey "FileVersion" "${ProgramVersion}"
VIAddVersionKey "LegalCopyright" "FOSS Walkman"
VIAddVersionKey "FileDescription" "${ProgramName} Installer"

LicenseBkColor /windows
LicenseData "LICENSE.md"
LicenseForceSelection checkbox "I have read and understand this notice"
LicenseText "Please read the notice below before installing ${ProgramName}. If you understand the notice, click the checkbox below and click Next."

InstallDir $PROGRAMFILES\WalkmanOSS
InstallDirRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "InstallLocation"
OutFile "bin\Release\${ProgramName}-Installer.exe"

; Pages

Page license
Page components
Page directory
Page instfiles
UninstPage uninstConfirm
UninstPage instfiles

; Sections

Section "Executable & Uninstaller"
  SectionIn RO
  SetOutPath $INSTDIR
  File "bin\Release\${ProgramName}.exe"
  File "bin\Release\${ProgramName}.exe.config"
  File "bin\Release\${ProgramName}.pdb"
  WriteUninstaller "${ProgramName}-Uninst.exe"
SectionEnd

Section "Add to Windows Programs & Features"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayName" "${ProgramName}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "Publisher" "WalkmanOSS"
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayIcon" "$INSTDIR\${ProgramName}.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "InstallLocation" "$INSTDIR\"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "UninstallString" "$INSTDIR\${ProgramName}-Uninst.exe"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "DisplayVersion" "${ProgramVersion}"
  
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "NoRepair" 1
  
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "HelpLink" "https://github.com/Walkman100/${ProgramName}/issues/new"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "URLInfoAbout" "https://github.com/Walkman100/${ProgramName}" ; Support Link
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" "URLUpdateInfo" "https://github.com/Walkman100/${ProgramName}/releases" ; Update Info Link
SectionEnd

Section "Start Menu Shortcuts"
  CreateDirectory "$SMPROGRAMS\WalkmanOSS"
  ;CreateShortCut "$SMPROGRAMS\WalkmanOSS\${ProgramName}.lnk" "$INSTDIR\${ProgramName}.exe" "" "$INSTDIR\${ProgramName}.exe" "" "" "" "${ProgramName}"
  CreateShortCut "$SMPROGRAMS\WalkmanOSS\Uninstall ${ProgramName}.lnk" "$INSTDIR\${ProgramName}-Uninst.exe" "" "" "" "" "" "Uninstall ${ProgramName}"
  ; Syntax for CreateShortCut: link.lnk target.file [parameters [icon.file [icon_index_number [start_options [keyboard_shortcut [description]]]]]]
SectionEnd

Section "Register to open Images"
  ; create ${ProgramName}File registration
  WriteRegStr HKCR "${ProgramName}File" "" "Windows Photo Viewer File"
  WriteRegStr HKCR "${ProgramName}File" "FriendlyTypeName" "Windows Photo Viewer File"
    WriteRegStr HKCR "${ProgramName}File\DefaultIcon" "" "%SystemRoot%\System32\imageres.dll,-122" ; copied from HKCR\PhotoViewer.FileAssoc.Tiff\DefaultIcon
    WriteRegStr HKCR "${ProgramName}File\shell" "" "open"
      WriteRegStr HKCR "${ProgramName}File\shell\open" "MuiVerb" "@%ProgramFiles%\Windows Photo Viewer\photoviewer.dll,-3043" ; also copied from PhotoViewer
      WriteRegStr HKCR "${ProgramName}File\shell\open\command" "" "$\"$INSTDIR\${ProgramName}.exe$\" $\"%1$\""

  ; assign ${ProgramName}File registration to extensions
  WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe" "" "Windows Photo Viewer Launcher"
    WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities" "ApplicationIcon" "$INSTDIR\${ProgramName}.exe"
    WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities" "ApplicationName" "Windows Photo Viewer Launcher"
    WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities" "ApplicationDescription" "Launches Windows Photo Viewer"
    
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".bmp" "${ProgramName}File" ; taken from list on machine where WPV is registered correctly
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".dib" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".gif" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".ico" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".jfif" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".jpe" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".jpeg" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".jpg" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".jxr" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".png" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".tif" "${ProgramName}File"
      WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\Capabilities\FileAssociations" ".tiff" "${ProgramName}File"

    WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\DefaultIcon" "" "$INSTDIR\${ProgramName}.exe"
    WriteRegStr HKLM "Software\WalkmanOSS\${ProgramName}.exe\shell\open\command" "" "$\"$INSTDIR\${ProgramName}.exe$\""
  WriteRegStr HKLM "SOFTWARE\RegisteredApplications" "${ProgramName}" "Software\WalkmanOSS\${ProgramName}.exe\Capabilities"

  ExecShell "open" "ms-settings:defaultapps"
SectionEnd

; Functions

Function .onInit
  SetShellVarContext all
  SetAutoClose true
FunctionEnd

; Uninstaller

Section "Uninstall"
  Delete "$INSTDIR\${ProgramName}-Uninst.exe" ; Remove Application Files
  Delete "$INSTDIR\${ProgramName}.exe"
  Delete "$INSTDIR\${ProgramName}.exe.config"
  Delete "$INSTDIR\${ProgramName}.pdb"
  RMDir "$INSTDIR"
  
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${ProgramName}" ; Remove Windows Programs & Features integration (uninstall info)
  
  ;Delete "$SMPROGRAMS\WalkmanOSS\${ProgramName}.lnk" ; Remove Start Menu Shortcuts & Folder
  Delete "$SMPROGRAMS\WalkmanOSS\Uninstall ${ProgramName}.lnk"
  RMDir "$SMPROGRAMS\WalkmanOSS"
  
  ; Remove File registrations
  DeleteRegKey HKCR "${ProgramName}File"
  DeleteRegKey HKLM "Software\WalkmanOSS\${ProgramName}.exe"
  DeleteRegValue HKLM "SOFTWARE\RegisteredApplications" "${ProgramName}"
SectionEnd

; Uninstaller Functions

Function un.onInit
  SetShellVarContext all
  SetAutoClose true
FunctionEnd

Function un.onUninstFailed
  MessageBox MB_OK "Uninstall Cancelled"
FunctionEnd

Function un.onUninstSuccess
  MessageBox MB_OK "Uninstall Completed"
FunctionEnd
