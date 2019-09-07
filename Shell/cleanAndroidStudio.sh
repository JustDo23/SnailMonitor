#!/bin/sh # 指定脚本解释器位置
echo "----- Begin Clean Android Stuido  -----"
echo "===>>> Are you sure to uninstall Android Studio?"
echo -n "(y/n) :" # 等待输入
read isUninstall # 接收输入
if [[ $isUninstall = "y" ]]; then
    echo "===>>> Execute script."
    # 卸载程序脚本
    rm -Rf /Applications/Android\ Studio.app
    rm -Rf ~/Library/Preferences/AndroidStudio*
    rm ~/Library/Preferences/com.google.android.studio.plist
    rm -Rf ~/Library/Application\ Support/AndroidStudio*
    rm -Rf ~/Library/Logs/AndroidStudio*
    rm -Rf ~/Library/Caches/AndroidStudio*
    rm -Rf ~/.AndroidStudio*
    # 删除默认项目路径
    rm -Rf ~/AndroidStudioProjects
    # 删除默认 SDK 路径
    rm -Rf ~/Library/Android*
    # 删除模拟器
    rm -Rf ~/.android
    # 删除模拟器验证令牌
    rm -Rf ~/.emulator_console_auth_token
else
    echo "===>>> Stop uninstall."
fi
echo "----- End Clean Android Stuido  -----"

echo ">>>"
echo ">>>"
echo ">>>"

echo "----- Begin Clean Gradle  -----"
echo "===>>> Are you want to delete Gradle?"
echo -n "(y/n) :" # 等待输入
read isDelete # 接收输入
if [[ $isDelete = "y" ]]; then
echo "===>>> Execute script."
    # 删除 Gradle
    rm -Rf ~/.gradle
else
    echo "===>>> Stop delete Gradle."
fi
echo "----- End Clean Gradle  -----"
