!include LogicLib.nsh
!include nsDialogs.nsh

!define PRODUCT_NAME "Qt3D"
!define PRODUCT_VERSION "1.0"
!define PRODUCT_PUBLISHER "Nokia"
!define PRODUCT_WEB_SITE "http://doc.qt.nokia.com/qt-qt3d-snapshot/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\qglinfo.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"

; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "src\scripts\quick3d.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "src\scripts\win_installer_background.bmp"
!define MUI_WELCOMEPAGE_TITLE "${PRODUCT_NAME} Setup"
!define MUI_WELCOMEPAGE_TEXT "${PRODUCT_NAME} will be installed into Qt ${QT_VERSION}, found in $INSTDIR.  If you do not want ${PRODUCT_NAME} installed there, click cancel below."

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "src\scripts\LICENSE.LGPL.txt"
; Directory page
; Disable this since we only install where we detect the right Qt
; !insertmacro MUI_PAGE_DIRECTORY
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
!define MUI_FINISHPAGE_NOAUTOCLOSE
; Finish page
Page custom DisplayWelcomeMessage
!define MUI_FINISHPAGE_RUN $INSTDIR\qt3d\bin\run_start_program.bat
!define MUI_FINISHPAGE_RUN_TEXT "Run Qt3D QGLInfo program"
!define MUI_FINISHPAGE_LINK "Qt3D documentation"
!define MUI_FINISHPAGE_LINK_LOCATION $INSTDIR\qt3d\doc\html\index.html

!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

; Where make install puts all the files
!define MK_INST_ROOT tmp

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME}-${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\Qt\${PRODUCT_VERSION}\qt3d"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

; HKCU\Software\Trolltech\Versions\DefaultQtVersion REG_SZ "${QT_VERSION}"
; HKCU\Software\Trolltech\Versions\${QT_VERSION}\InstallDir REG_SZ "C:\Qt\${QT_VERSION}"

Function .onInit
  ;LogSet on
  ReadRegStr $0 HKCU "Software\Trolltech\Versions\${QT_VERSION}" "InstallDir"
  ${If} $0 == ""
    MessageBox MB_ICONEXCLAMATION "Please install Qt v${QT_VERSION} MSVC from http:\\qt.nokia.com\downloads before installing ${PRODUCT_NAME} ${PRODUCT_VERSION}"
    Abort
  ${EndIf}
  StrCpy $INSTDIR $0
FunctionEnd

Function DisplayWelcomeMessage
        ; Create the temporary plugins directory
        InitPluginsDir

        ; Put the welcome message in the temporary plugins directory.
        ; The plugins directory is deleted when the installer quits.
        File "/oname=$PLUGINSDIR\windows-install.txt" "src\scripts\windows-install.txt"

        nsDialogs::Create 1018
        Pop $0

        nsDialogs::CreateControl /NOUNLOAD ${__NSD_Text_CLASS} ${DEFAULT_STYLES}|${WS_TABSTOP}|${ES_MULTILINE} ${__NSD_Text_EXSTYLE} 20 45 325 200 ''
        Pop $1

        CustomLicense::LoadFile "$PLUGINSDIR\windows-install.txt" $1
        nsDialogs::Show

FunctionEnd

Section "MainSection" SEC01
  SetOverwrite try
  CreateDirectory "$SMPROGRAMS\Qt3D"
  CreateDirectory "$SMPROGRAMS\Qt3D\Examples"
  CreateDirectory "$SMPROGRAMS\Qt3D\Demos"

  ; For the CreateShortCut command, the outpath is actually used for the working directory.
  ; By setting $INSTDIR\bin to the working directory all these lnk targets should be able
  ; to find their dependent dll's without needing to set the path
  SetOutPath "$INSTDIR\bin"
  CreateShortCut "$SMPROGRAMS\Qt3D\Qt3D.lnk" "$INSTDIR\qt3d\bin\qglinfo.exe"
  CreateShortCut "$DESKTOP\Qt3D.lnk" "$INSTDIR\qt3d\bin\qglinfo.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Basket.lnk" "$INSTDIR\qt3d\bin\basket_qml.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Cube.lnk" "$INSTDIR\qt3d\bin\cube_qml.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Forest.lnk" "$INSTDIR\qt3d\bin\forest_qml.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Lander.lnk" "$INSTDIR\qt3d\bin\lander.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Matrix Animation.lnk" "$INSTDIR\qt3d\bin\matrix_animation.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Monkey God.lnk" "$INSTDIR\qt3d\bin\monkeygod.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Moon.lnk" "$INSTDIR\qt3d\bin\moon.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Photo Room.lnk" "$INSTDIR\qt3d\bin\photoroom.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Shaders.lnk" "$INSTDIR\qt3d\bin\shaders.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Sphere.lnk" "$INSTDIR\qt3d\bin\sphere.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Teapot.lnk" "$INSTDIR\qt3d\bin\teapot_qml.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Teapot Bounce.lnk" "$INSTDIR\qt3d\bin\teapot_bounce_qml.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Basket (C++).lnk" "$INSTDIR\qt3d\bin\basket.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Builder.lnk" "$INSTDIR\qt3d\bin\builder.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Cube (C++).lnk" "$INSTDIR\qt3d\bin\cube.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Cylinder.lnk" "$INSTDIR\qt3d\bin\cylinder.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Geometry.lnk" "$INSTDIR\qt3d\bin\geometry.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Graphicsview.lnk" "$INSTDIR\qt3d\bin\graphicsview.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Nesting.lnk" "$INSTDIR\qt3d\bin\nesting.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Tank.lnk" "$INSTDIR\qt3d\bin\tank.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Examples\Teapot (C++).lnk" "$INSTDIR\qt3d\bin\teapot.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Model Viewer.lnk" "$INSTDIR\qt3d\bin\model_viewer.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Robo Bounce.lnk" "$INSTDIR\qt3d\bin\robo_bounce.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Tea Service.lnk" "$INSTDIR\qt3d\bin\tea_service.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Cube House.lnk" "$INSTDIR\qt3d\bin\cubehouse.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Page Flip.lnk" "$INSTDIR\qt3d\bin\pageflip.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Photo-browser 3D.lnk" "$INSTDIR\qt3d\bin\photobrowser3d.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Shapes.lnk" "$INSTDIR\qt3d\bin\shapes.exe"
  CreateShortCut "$SMPROGRAMS\Qt3D\Demos\Tea Service (C++).lnk" "$INSTDIR\qt3d\bin\teaservice.exe"

  ; bin imports include lib mkspecs plugins qt3d
  SetOutPath "$INSTDIR\qt3d\bin"
  File "${MK_INST_ROOT}${QT_PREFIX_PATH}\bin\*.exe"
  File /r "${MK_INST_ROOT}${QT_PREFIX_PATH}\quick3d\resources"
  SetOutPath "$INSTDIR\lib"
  File "${MK_INST_ROOT}${QT_PREFIX_PATH}\bin\*.lib"
  SetOutPath "$INSTDIR\qt3d\doc"
  File /r "doc\html"
  SetOutPath "$INSTDIR\bin"
  File "${MK_INST_ROOT}${QT_PREFIX_PATH}\bin\*.dll"
  SetOutPath "$INSTDIR"
  File /r "${MK_INST_ROOT}${QT_PREFIX_PATH}\imports"
  File /r "${MK_INST_ROOT}${QT_PREFIX_PATH}\include"
  File /r "${MK_INST_ROOT}${QT_PREFIX_PATH}\mkspecs"
  File /r "${MK_INST_ROOT}${QT_PREFIX_PATH}\plugins"

  ClearErrors
  FileOpen $0 $INSTDIR\qt3d\bin\run_start_program.bat w
  IfErrors done
  FileWrite $0 "start /D $INSTDIR\bin $INSTDIR\qt3d\bin\qglinfo.exe"
  FileClose $0
  done:
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\Qt3D\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\Qt3D\Uninstall.lnk" "$INSTDIR\qt3d\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\qt3d\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\qt3d\bin\qglinfo.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\qt3d\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\qt3d\bin\qglinfo.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallRoot" "$INSTDIR"
SectionEnd


Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  ; LogSet on
  ReadRegStr $0 ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "InstallRoot"
  StrCpy $INSTDIR $0
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\qt3d\uninst.exe"
  RMDir /r "$INSTDIR\plugins\sceneformats"
  Delete "$INSTDIR\plugins\imageformats\qtga4.dll"
  Delete "$INSTDIR\mkspecs\features\qt3dquick.prf"
  Delete "$INSTDIR\mkspecs\features\qt3d.prf"
  Delete "$INSTDIR\lib\Qt3D.*"
  Delete "$INSTDIR\lib\Qt3Dd.*"
  Delete "$INSTDIR\bin\Qt3D.*"
  Delete "$INSTDIR\bin\Qt3Dd.*"
  Delete "$INSTDIR\bin\Qt3D.*"
  Delete "$INSTDIR\bin\Qt3Dd.*"
  RMDir /r "$INSTDIR\include\Qt3D"
  RMDir /r "$INSTDIR\include\Qt3D"
  RMDir /r "$INSTDIR\imports\Qt3D"
  RMDir /r "$INSTDIR\qt3d"

  Delete "$DESKTOP\Qt3D.lnk"
  RMDir /r "$SMPROGRAMS\Qt3D"
  RMDir /r "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Qt3D"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
