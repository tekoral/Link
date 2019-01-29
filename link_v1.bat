:: Initialization

@echo off
setlocal
cls

del CDUMP
del CDUMP_*
del ready_for_HS
del ready_for_NL

type NUL > not_ready_for_HS
type NUL > not_ready_for_NL

:START_MAIN_LOOP

:: Are configuration files (EMITIMES & CONTROL) ready for HYSPLIT?

echo Waiting for NetLogo...
:WAIT_FOR_NL

rename ready_for_HS ready_for_HS 2> NUL

if %errorlevel% EQU 0 (
	del CDUMP
	rename ready_for_HS not_ready_for_HS
	C:\hysplit4\exec\hycs_std.exe
) else (
	goto WAIT_FOR_NL
)

:: Is binary concentration file ready for conversion to ASCII?

echo Waiting for HYSPLIT...
:WAIT_FOR_HS

rename CDUMP CDUMP 2> NUL

if %errorlevel% EQU 0 (
	del EMITIMES
	del CONTROL
	C:\hysplit4\exec\con2asc.exe -iCDUMP
	rename not_ready_for_NL ready_for_NL
) else (
	goto WAIT_FOR_HS
)

:: Repeat

goto START_MAIN_LOOP
