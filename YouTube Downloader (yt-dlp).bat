@echo off

title youtube-dl - Download Your Shit (https://github.com/yt-dlp/yt-dlp)

:askMode
	echo Modes:
	echo 1. Videos
	echo 2. Playlist/Music
	set /P mode="Choose mode: "

if "%mode%" gtr "2" (
	echo.
	echo THAT AIN'T IT CHIEF!
	echo.
	goto :askMode
)

if "%mode%" lss "1" (
	echo.
	echo THAT AIN'T IT CHIEF!
	echo.
	goto :askMode
)

echo.
echo Extensions:
echo m4a, mp3, mp4
set /P extension="Choose extension: "

echo.
start urls.txt
set /P pause="Paste your URLs into 'urls.txt', save the file then hit ENTER."

if "%mode%" equ "1" (
	set params=^
		-f "bv[height<=1440][vcodec^=avc]+ba[ext=%extension%]" ^
		-a urls.txt ^
		--embed-chapters ^
		--embed-metadata ^
		--embed-thumbnail ^
		--convert-thumbnail jpg ^
		--embed-subs ^
		--sub-langs en.* ^
		-o "D:\HDD Files\Videos\youtube-dl\Videos\%%(uploader)s\%%(title)s.%%(ext)s"
)

if "%mode%" equ "2" (
	set params=^
		-ciw ^
		-a urls.txt ^
		-f %extension% ^
		--embed-metadata ^
		-o "D:\HDD Files\Videos\youtube-dl\Music\%%(uploader)s\%%(playlist_index)s - %%(title)s.%%(ext)s"
)

yt-dlp.exe ^
%params%

pause
