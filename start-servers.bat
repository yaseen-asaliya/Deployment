@echo off
REM One-shot launcher for V2, V3, V4 local dev servers on Windows.
REM V1 Flutter needs a separate Flutter SDK install — see START-LOCAL-TESTING.md.

set ROOT=%~dp0
set HS="%ROOT%_tools\node_modules\.bin\http-server.cmd"

if not exist %HS% (
  echo http-server not found at %HS%
  echo Run: cd "%ROOT%_tools" ^&^& npm install
  pause
  exit /b 1
)

echo Starting V2 Astro on http://localhost:8002/ ...
start "V2 Astro"     cmd /k %HS% "%ROOT%02-astro\dist" -p 8002 -c-1

echo Starting V3 Next.js on http://localhost:8003/ ...
start "V3 Next.js"   cmd /k %HS% "%ROOT%03-nextjs\out" -p 8003 -c-1

echo Starting V4 Plain HTML on http://localhost:8004/ ...
start "V4 Plain HTML" cmd /k %HS% "%ROOT%04-plain-html" -p 8004 -c-1

timeout /t 2 /nobreak >nul
echo.
echo All three servers starting. Open these in your browser:
echo   V2 Astro:      http://localhost:8002/    (AR: /ar/)
echo   V3 Next.js:    http://localhost:8003/    (AR: /ar/)
echo   V4 Plain HTML: http://localhost:8004/    (AR: /ar.html)
echo.
echo Each server runs in its own window. Close the window to stop that server.
pause
