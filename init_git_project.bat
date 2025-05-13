@echo off
setlocal EnableDelayedExpansion

echo === Inicializando repositorio Git en: %CD%

REM Verifica si ya es un repositorio Git
git rev-parse --is-inside-work-tree >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo No se detecta repositorio Git. Inicializando...
    git init -b main
) else (
    echo Ya existe un repositorio Git en este directorio.
)

echo.

REM Configurar usuario si no está configurado globalmente
git config --get user.name >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    set /p GITUSER="Ingrese su nombre para Git (user.name): "
    git config --global user.name "!GITUSER!"
)

git config --get user.email >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    set /p GITEMAIL="Ingrese su email para Git (user.email): "
    git config --global user.email "!GITEMAIL!"
)

echo.

REM Primer commit si es necesario
git rev-parse HEAD >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Realizando primer commit...
    git add .
    git commit -m "Initial commit"
) else (
    echo Ya existe al menos un commit.
)

echo.

REM Verificar remoto
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    set /p REMOTE_URL="No hay remoto. Introduzca la URL del repositorio remoto (o deje en blanco para omitir): "
    if not "!REMOTE_URL!"=="" (
        git remote add origin !REMOTE_URL!
        git push -u origin main
    ) else (
        echo No se añadió remoto.
    )
) else (
    echo Remoto 'origin' ya está configurado.
    set /p DO_PUSH="¿Deseas hacer push al repositorio remoto ahora? (y/n): "
    if /i "!DO_PUSH!"=="y" (
        git status
        git add .
        set /p COMMIT_MSG="Mensaje para el commit: "
        git commit -m "!COMMIT_MSG!"
        git push
    ) else (
        echo Push omitido.
    )
)

echo.
echo === PROCESO TERMINADO ===
pause
