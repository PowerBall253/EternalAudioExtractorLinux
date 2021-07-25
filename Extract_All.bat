@ECHO OFF


SETLOCAL
SET ___BATCH_DATE=2021-05-25
TITLE Extract_All.bat    (%___BATCH_DATE%)
ECHO/
ECHO 	[44;96m                                             [0m 
ECHO 	[44;96m  Extract_All.bat                            [0m 
ECHO 	[44;96m      by proteh, dated %___BATCH_DATE%            [0m 
ECHO 	[44;96m      based on a script by Zwip-Zwap Zapony  [0m 
ECHO 	[44;96m                                             [0m 
ECHO/
ECHO/
ECHO/
ECHO/


2>NUL VERIFY/
SETLOCAL ENABLEEXTENSIONS

IF ERRORLEVEL 1 (
	ECHO 	[1;41;93mERROR: Command Processor Extensions are unavailable![0m 
	ECHO/
	ECHO 	This batch file requires command extensions, but they seem to be unavailable on your system.
	ECHO/
	PAUSE
	EXIT /B 1
)
IF NOT CMDEXTVERSION 2 (
	ECHO 	[1;41;93mERROR: Command Processor Extensions are of version 1![0m 
	ECHO/
	ECHO 	Command extensions seem to be available on your system, but only of version 1. This batch file was designed for version 2.
	ECHO/
	PAUSE
	EXIT /B 1
)

SET ___EXTRACTOR_OPTIONS=
SET ___GAME_SOUND_FILES_DIRECTORY=
SET ___OUTPUT_DIRECTORY=

SET CD=

2>NUL CD /D %~dp0





ECHO 	This batch file runs EternalAudioExtractor to extract the contents of all of DOOM Eternal's *.snd archives in one go.
ECHO/
ECHO/
ECHO 	Please input the full path to your DOOM Eternal installation:

CALL :FunctionAskForDirectory ___GAME_SOUND_FILES_DIRECTORY

IF NOT EXIST "%___GAME_SOUND_FILES_DIRECTORY%\base\sound\soundbanks\pc\music.snd" GOTO MissingResources
IF NOT EXIST "%___GAME_SOUND_FILES_DIRECTORY%\base\sound\soundbanks\pc\mus.pck" GOTO MissingResources
IF NOT EXIST "%___GAME_SOUND_FILES_DIRECTORY%\base\sound\soundbanks\pc\soundmetadata.bin" GOTO MissingResources


ECHO/
ECHO 	DOOM Eternal sound files found!
ECHO/
ECHO/
ECHO 	Please input the full filepath to where you want to extract the sound files to.
ECHO 	Make sure that this filepath leads to a folder that's either empty or nonexistent:


CALL :FunctionAskForDirectory ___OUTPUT_DIRECTORY

FOR %%A IN ("%___OUTPUT_DIRECTORY%\*") DO GOTO OutputIsntEmpty
FOR /D %%A IN ("%___OUTPUT_DIRECTORY%\*") DO GOTO OutputIsntEmpty


ECHO/
ECHO 	Output directory set!
ECHO/
ECHO/
ECHO 	Do you want to automatically convert extracted .wem sound files to the .ogg format?
ECHO/
ECHO 	[1mPlease note that converting sound files [4mmight[0;1m take a long time depending on your CPU speed![0m
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to enable automatic .ogg sound file conversion.)
<NUL SET /P ="(Press [1m[N][0m to disable automatic .ogg sound file conversion.) "
CHOICE /C YN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF NOT ERRORLEVEL 2 SET ___EXTRACTOR_OPTIONS=-c 


ECHO     Do you also want to extract unused game sound files?
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to enable unused game sound files extraction.)
<NUL SET /P ="(Press [1m[N][0m to disable unused game sound files extraction.) "
CHOICE /C YN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF DEFINED ___EXTRACTOR_OPTIONS (
    IF NOT ERRORLEVEL 2 SET ___EXTRACTOR_OPTIONS=%___EXTRACTOR_OPTIONS%-u
) ELSE IF NOT ERRORLEVEL 2 SET ___EXTRACTOR_OPTIONS=-u 

ECHO/
ECHO 	All set!
ECHO/
ECHO/
ECHO 	[1mPlease note that extracting all *.snd archives [4mmight[0;1m take a long time, depending on your CPU and storage speed![0m
ECHO/
ECHO 	And, just to make sure, does this look correct?
ECHO/
CALL :FunctionEchoPath "DOOM Eternal path:      " "%___GAME_SOUND_FILES_DIRECTORY%"
CALL :FunctionEchoPath "Output:                 " "%___OUTPUT_DIRECTORY%"
(ECHO %___EXTRACTOR_OPTIONS% | FINDSTR /I /C:"-c" >NUL) && (ECHO 	Convert to .wem to .ogg: Yes) || (ECHO 	Convert to .wem to .ogg: No)
(ECHO %___EXTRACTOR_OPTIONS% | FINDSTR /I /C:"-u" >NUL) && (ECHO 	Extract unused:          Yes) || (ECHO 	Extract unused:          No)
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to extract *.snd archives to the output folder.)
<NUL SET /P ="(Press [1m[N][0m to abort and close this batch file.) "
CHOICE /C YN /N
ECHO/
ECHO/

IF NOT ERRORLEVEL 1 EXIT /B 1
IF ERRORLEVEL 2 EXIT /B 1

FOR %%A IN ("%___GAME_SOUND_FILES_DIRECTORY%\base\sound\soundbanks\pc\*.snd") DO CALL :FunctionExtractResources "%%~fA"

TITLE Extract_All.bat    (%___BATCH_DATE%)
ECHO/
ECHO/
ECHO/
ECHO/
ECHO 	Finished extracting all *.snd archives!
CALL :FunctionEchoPath "You can find the output in" "%___OUTPUT_DIRECTORY%"
ECHO/
ECHO 	Do you want to open the output folder now?
ECHO/
ECHO/
ECHO (Press [1m[Y][0m to close this batch file and open File Explorer in the output folder.)
<NUL SET /P ="(Press [1m[N][0m to close this batch file without opening File Explorer.) "
CHOICE /C YN /N

IF NOT ERRORLEVEL 1 EXIT /B 0
IF ERRORLEVEL 2 EXIT /B 0

explorer "%___OUTPUT_DIRECTORY%"

EXIT /B 0





:MissingOutput
TITLE Extract_All.bat    (%___BATCH_DATE%)
ECHO/
ECHO/
CALL :FunctionEchoError Couldn't create output directory!
ECHO/
ECHO 	Are you out of space on your storage medium, or did you use an invalid output path?
CALL :FunctionEchoPath "The output directory path that you gave was" "%___OUTPUT_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1


:MissingResources
CALL :FunctionEchoError "music.snd" not found!
ECHO/
ECHO 	Is your DOOM Eternal installation incomplete, or did you use a wrong path?
ECHO 	music.snd should be located at -/DOOMEternal/base/sound/soundbanks/pc/music.snd
CALL :FunctionEchoPath "The path that you gave to -/DOOMEternal/ was" "%___GAME_SOUND_FILES_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1


:OutputIsntEmpty
CALL :FunctionEchoError Output directory not empty!
ECHO/
ECHO 	To avoid inconveniencing you, this batch file won't extract to an output directory that already has files and/or folders in it.
CALL :FunctionEchoPath "The output directory path that you gave was" "%___OUTPUT_DIRECTORY%"
ECHO/
PAUSE
EXIT /B 1





:FunctionAskForDirectory
SET /P ___TEMP=
IF NOT DEFINED ___TEMP SET ___TEMP=.

SET ___TEMP=%___TEMP:"=%
IF NOT DEFINED ___TEMP SET ___TEMP=.
SET ___TEMP=%___TEMP:/=\%
IF NOT DEFINED ___TEMP SET ___TEMP=.

IF "%___TEMP:~-1%"=="\" SET ___TEMP=%___TEMP:~0,-1%

IF NOT DEFINED ___TEMP (
	SET %1=.
) ELSE SET %1=%___TEMP%

EXIT /B 0


:FunctionEchoError
ECHO/
ECHO/
ECHO 	[1;41;93mERROR: %*[0m 
EXIT /B 0


:FunctionEchoPath
SET ___TEMP=%~2
IF "%___TEMP:~0,2%"=="." GOTO FunctionEchoPathCD
ECHO 	%~1 %___TEMP:\=/%/
EXIT /B 0
:FunctionEchoPathCD
ECHO 	%~1 %CD:\=/%/
EXIT /B 0


:FunctionExtractResources
EternalAudioExtractor.exe "%~f1" "%___GAME_SOUND_FILES_DIRECTORY%\base\sound\soundbanks\pc" "%___OUTPUT_DIRECTORY%" %___EXTRACTOR_OPTIONS%
EXIT /B 0