@echo off
cd /d %~dp0

chcp 65001 > nul

set "source_folder=book"  
set "destination_folder=\\192.168.0.111\home\www"  
  
:: 确保目标文件夹存在，如果不存在则创建它  
if not exist "%destination_folder%" (
	mkdir "%destination_folder%" 
) else (
	::del "%destination_folder%" 
	del /Q /S "%destination_folder%" > NUL 2>&1
	::del 移除空的文件夹
	rd /S /Q "%destination_folder%" > NUL 2>&1
	echo "清空文件夹： %destination_folder%"
)

:: 复制文件夹  
xcopy /E /I /Y /Q "%source_folder%" "%destination_folder%" > NUL 2>&1


echo "复制完成！"