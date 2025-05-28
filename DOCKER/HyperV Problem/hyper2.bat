pushd "%~dp0"
dir /b %SystemRoot%\servicing\Packages\*HyperV*.mum >HyperV.txt
for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
pause