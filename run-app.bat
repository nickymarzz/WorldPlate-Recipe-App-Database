@echo off
title Recipe DB Showcase Studio Launcher
echo =====================================================================
echo           LAUNCHING RECIPE DB SHOWCASE STUDIO (DUAL-MODE)
echo =====================================================================
echo.
echo  [1/2] Starting SQL Server Express API Backend on port 5000...
start "Recipe DB API Backend" cmd /k "cd backend && npm run dev"

echo  [2/2] Starting React Frontend Dev Server on port 5173...
start "Recipe DB React Frontend" cmd /k "cd frontend && npm run dev"

echo.
echo  -----------------------------------------------------------------
echo   Success! Both services are launching in separate windows.
echo.
echo   - Interactive Web UI:  http://localhost:5173
echo   - Backend Server API:  http://localhost:5000
echo.
echo   Note:
echo   Make sure SQL Server is running in SSMS 22 and the schema
echo   is loaded if you wish to toggle into Live Connection Mode.
echo   Otherwise, the application will run in Demo mode automatically.
echo  -----------------------------------------------------------------
echo.
pause
