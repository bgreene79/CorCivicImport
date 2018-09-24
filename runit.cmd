SET server="CSPDB01"

echo Pre-Conversion Validation...
pause
sqlcmd -S %server% -i ".\Pre-Conversion Validation.sql" > PreConversion.txt

echo Patient...
pause
sqlcmd -S %server% -i ".\InsertPAT.sql"

echo Patient ALC...
pause
sqlcmd -S %server% -i ".\InsertPAT_ALC.sql"

echo Doctor...
pause
sqlcmd -S %server% -i ".\InsertDOC.sql"

echo Drug...
pause
sqlcmd -S %server% -i ".\InsertDRG.sql"

echo Rx...
pause
sqlcmd -S %server% -i ".\InsertRXF.sql"

echo Fill...
pause
sqlcmd -S %server% -i ".\InsertFIL.sql"

echo Dc Meds...
pause
sqlcmd -S %server% -i ".\InsertDCM.sql"

echo Rx Rollover...
pause
sqlcmd -S %server% -i ".\InsertRolledRXF.sql"

echo Fill Rollover...
pause
sqlcmd -S %server% -i ".\InsertRolledFIL.sql"

echo Post-Conversion Validation...
pause
sqlcmd -S %server% -i ".\Post-Conversion Validation.sql" > PostConversion.txt

echo Complete!




