@echo off
REM #!/usr/bin/env bash
REM
REM NOTE:
REM This doesn't work as is on Windows. You'll need to create an equivalent `.bat` file instead
REM
REM NOTE:
REM If you're not using Linux you'll need to adjust the `-configuration` option
REM to point to the `config_mac' or `config_win` folders depending on your system.
REM
REM To build eclipse.jdt java server
REM git clone https://github.com/eclipse/eclipse.jdt.ls.git
REM cd eclipse.jdt.ls
REM ./mvnw clean verify

set JDT_HOME=C:\Users\xxx\AppData\Local\nvim\eclipse.jdt.ls
set HOME=C:\users\xxx
set JAR=%JDT_HOME%\org.eclipse.jdt.ls.product\target\repository\plugins\org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar
set GRADLE_HOME=C:\users\xxx\apps\gradle 

java ^
  -Declipse.application=org.eclipse.jdt.ls.core.id1 ^
  -Dosgi.bundles.defaultStartLevel=4 ^
  -Declipse.product=org.eclipse.jdt.ls.core.product ^
  -Dlog.protocol=true ^
  -Dlog.level=ALL ^
  -Xms1g ^
  -Xmx2G ^
  -jar %JAR% ^
  -configuration "%JDT_HOME%\org.eclipse.jdt.ls.product\target\repository\config_linux" ^
  -data "%1" ^
  --add-modules=ALL-SYSTEM ^
  --add-opens java.base/java.util=ALL-UNNAMED ^
  --add-opens java.base/java.lang=ALL-UNNAMED
