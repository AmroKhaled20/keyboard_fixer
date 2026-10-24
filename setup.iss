[Setup]
AppName=Keyboard Fixer
AppVersion=1.0
AppPublisher=Amr Khalid
DefaultDirName={autopf}\Keyboard Fixer
DisableProgramGroupPage=yes
; «·√ÌﬁÊ‰… «··Ì Â ŸÂ— ·„·› «·‹ Setup
SetupIconFile=D:\DesktopApps\keyboard_fixer\windows\runner\resources\app_icon.ico
; „”«— Õ›Ÿ „·› «·‹ Setup «·‰Â«∆Ì
OutputDir=D:\DesktopApps\keyboard_fixer
OutputBaseFilename=KeyboardFixer_Setup
Compression=lzma
SolidCompression=yes
ArchitecturesInstallIn64BitMode=x64

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "D:\DesktopApps\keyboard_fixer\build\windows\x64\runner\Release\keyboard_fixer.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\DesktopApps\keyboard_fixer\build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\DesktopApps\keyboard_fixer\build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\Keyboard Fixer"; Filename: "{app}\keyboard_fixer.exe"
Name: "{autodesktop}\Keyboard Fixer"; Filename: "{app}\keyboard_fixer.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\keyboard_fixer.exe"; Description: "{cm:LaunchProgram,Keyboard Fixer}"; Flags: nowait postinstall skipifsilent