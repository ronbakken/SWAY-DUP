xcopy /Y ..\sway_config\blob\config_local.bin assets\config.bin
robocopy android\key.properties.sway-dev android\key.properties /z /r:0

echo "Switch to the Debug Console to continue"
