@echo off

title YouTube Downloader (yt-dlp)

:askMode
	echo Modes:
	echo 1. Videos
	echo 2. Playlist/Music
	set /P mode="Choose mode: "

if "%mode%" gtr "2" (
	echo.
	echo Not a recognized mode!
	echo.
	goto :askMode
)

if "%mode%" lss "1" (
	echo.
	echo Not a recognized mode!
	echo.
	goto :askMode
)

if not exist "backend\urls.txt" (
	type nul > backend\urls.txt
	start backend\urls.txt
	set /P pause="Paste your URLs into 'urls.txt', save the file then hit ENTER."
) else (
	echo.
	start backend\urls.txt
	set /P pause="Paste your URLs into 'urls.txt', save the file then hit ENTER."
)

if "%mode%" equ "1" (
	set params=^
		--ffmpeg-location "backend\ffmpeg\ffmpeg.exe" ^
		-f "bv[height<=1440][vcodec^=avc]+ba[ext=m4a]" ^
		-a backend\urls.txt ^
		--embed-chapters ^
		--embed-metadata ^
		--embed-thumbnail ^
		--convert-thumbnail jpg ^
		--embed-subs ^
		--sub-langs en.* ^
		-o "downloads\Videos\%%(uploader)s\%%(title)s.%%(ext)s"
)

if "%mode%" equ "2" (
	set params=^
		--ffmpeg-location "backend\ffmpeg\ffmpeg.exe" ^
		-ciw ^
		-a backend\urls.txt ^
		-f m4a ^
		--embed-metadata ^
		-o "downloads\Music\%%(uploader)s\%%(title)s.%%(ext)s"
)

backend\yt-dlp.exe ^
%params%

pause
