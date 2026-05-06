@echo off
setlocal
:: Use short paths to avoid space-in-path issues
set "PUB_CACHE=C:\Users\MYLENO~1\AppData\Local\Pub\Cache"
set "FLUTTER_ROOT=C:\Users\MYLENO~1\flutter"
set "PATH=%FLUTTER_ROOT%\bin;%PATH%"

echo Running Flutter build with short paths...
call flutter build apk --debug

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Build failed. If the error persists, consider moving the Flutter SDK to C:\flutter
    exit /b %ERRORLEVEL%
)

echo.
echo Build successful!
endlocal
