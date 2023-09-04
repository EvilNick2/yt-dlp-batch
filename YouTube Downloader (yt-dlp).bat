@echo off

title YouTube Downloader (yt-dlp)

echo =====================================================
echo   __   __   _____           ____     _        ____
echo   \ \_/ /  ^|_   _^|   ___   ^|  _ \   ^| ^|      ^|  _ \
echo    \   /     ^| ^|    ^|___^|  ^| ^| \ \  ^| ^|      ^|  __/
echo     ^| ^|      ^| ^|           ^| ^|_/ /  ^| ^|___   ^| ^|
echo     ^|_^|      ^|_^|           ^|____/   ^|_____^|  ^|_^|
echo.
echo =====================================================
echo.

:askMode
	echo --- DOWNLOAD MODES ---
	echo 1. Videos
	echo 2. Music
	echo.

set /P "mode=Choose mode: "

if "%mode%" lss "1" (
    echo.
    echo Not a recognized mode!
    echo.
    goto :askMode
)

if "%mode%" gtr "2" (
    echo.
    echo Not a recognized mode!
    echo.
    goto :askMode
)

if "%mode%" equ "1" (
    set params=^
    	--ffmpeg-location "backend\ffmpeg\ffmpeg.exe" ^
    	-f "bv[height<=1080][vcodec^=avc]+ba[ext=m4a]" ^
		-a backend\video_urls.txt ^
		--embed-chapters ^
		--embed-metadata ^
		--embed-thumbnail ^
		--convert-thumbnail jpg ^
		--embed-subs ^
		--sub-langs en.* ^
		-o "Downloads\Videos\%%(uploader)s\%%(playlist_index)s - %%(title)s.%%(ext)s"

	set "prompt=promptVideoUrl"
)

if "%mode%" equ "2" (
    set params=^
		--ffmpeg-location "backend\ffmpeg\ffmpeg.exe" ^
		-ciw ^
		-a backend\music_urls.txt ^
		-f m4a ^
		--embed-metadata ^
		-o "Downloads\Music\%%(uploader)s\%%(playlist_index)s - %%(title)s.%%(ext)s"

	set "prompt=promptMusicUrl"
)

:: Calls the function to prompt for either video or music URLs
goto %prompt%

:promptVideoUrl
call :promptUrls "video_urls.txt" "video"
goto :download

:promptMusicUrl
call :promptUrls "music_urls.txt" "music"
goto :download

:promptUrls
if not exist "backend\%~1" (
    type nul > "backend\%~1"
    start backend\%~1

    echo.
    set /P "pause=Paste your URLs into '%~1', save the file then hit ENTER."
) else (
    start backend\%~1

    echo.
    set /P "pause=Paste your URLs into '%~1', save the file then hit ENTER."
)
exit /b

:download
backend\yt-dlp.exe %params%
echo.
echo ============================
echo      DOWNLOAD COMPLETE!     
echo ============================
echo.

:: Open the options again
goto :askMode

pause
exit /b
