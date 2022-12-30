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

if "%mode%" equ "1" (
	echo.
	goto :videoOrdered
)

if "%mode%" equ "2" (
	echo.
	goto :musicOrdered
)

:videoOrdered
	set /P videoPL="Make video playlist ordered? (Y/N) "

if "%videoPL%" equ "" (
	echo Input cannot be empty!
	goto :videoOrdered
)

if "%videoPL%" equ "y" (
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

		goto :promptVideoUrl
)

if "%videoPL%" equ "n" (
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
		-o "Downloads\Videos\%%(uploader)s\%%(title)s.%%(ext)s"

	goto :promptVideoUrl
)

:musicOrdered
	set /P musicPL="Make audio playlist ordered? (Y/N) "

if "%musicPL%" equ "" (
	echo Input cannot be empty!
	goto :musicOrdered
)

if "%musicPL%" equ "y" (
	set params=^
		--ffmpeg-location "backend\ffmpeg\ffmpeg.exe" ^
		-ciw ^
		-a backend\music_urls.txt ^
		-f m4a ^
		--embed-metadata ^
		-o "Downloads\Music\%%(uploader)s\%%(playlist_index)s - %%(title)s.%%(ext)s"

	goto :promptMusicUrl
)

if "%musicPL%" equ "n" (
	set params=^
		--ffmpeg-location "backend\ffmpeg\ffmpeg.exe" ^
		-ciw ^
		-a backend\music_urls.txt ^
		-f m4a ^
		--embed-metadata ^
		-o "Downloads\Music\%%(uploader)s\%%(title)s.%%(ext)s"

	goto :promptMusicUrl
)


:promptVideoUrl
	if not exist "backend\video_urls.txt" (
		type nul > backend\video_urls.txt
		start backend\video_urls.txt

		echo.
		set /P pause="Paste your URLs into 'video_urls.txt', save the file then hit ENTER."

		goto :download
	) else (
		start backend\video_urls.txt
		
		echo.
		set /P pause="Paste your URLs into 'video_urls.txt', save the file then hit ENTER."

		goto :download
	)


:promptMusicUrl
	if not exist "backend\music_urls.txt" (
		type nul > backend\music_urls.txt
		start backend\music_urls.txt

		echo.
		set /P pause="Paste your URLs into 'music_urls.txt', save the file then hit ENTER."

		goto :download
	) else (
		start backend\music_urls.txt
		
		echo.
		set /P pause="Paste your URLs into 'music_urls.txt', save the file then hit ENTER."

		goto :download
	)

:download
	backend\yt-dlp.exe ^
	%params%

	echo.
	echo DOWNLOAD COMPLETE!

pause
