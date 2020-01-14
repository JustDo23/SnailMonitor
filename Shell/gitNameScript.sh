#!/bin/sh # 指定脚本解释器为 /bin/sh
echo "----- Begin Git Script -----" # 输出提示语
echo "===>>> Current Git Config:"
echo -n "===>>> userName = "
git config user.name
echo -n "===>>> userEmail = "
git config user.email
echo "===>>> This is set for GitHub?"
echo -n "(y/n) :" # 等待输入
read isGitHub # 读取用户输入
if [[ $isGitHub = "y" ]]; then
    echo "===>>> Config For GitHub."
    git config --global user.name "JustDo23"
    git config --global user.email 757307903@qq.com
else
    echo "===>>> Config For Company."
    git config --global user.name "JustDo23"
    git config --global user.email 757307903@qq.com
fi
echo "===>>> Current Git Config:"
echo -n "===>>> userName = "
git config user.name
echo -n "===>>> userEmail = "
git config user.email
echo "----- End Git Script -----"
