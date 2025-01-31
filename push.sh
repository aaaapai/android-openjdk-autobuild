#!/bin/bash

# 创建 SSH 目录
mkdir -p ~/.ssh

# echo "将私钥写入文件"
echo "${SSH_PRIVATE_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# echo "添加 GitHub 主机密钥"
ssh-keyscan github.com >> ~/.ssh/known_hosts

# echo "启动 SSH 代理并添加密钥"
eval $(ssh-agent -s)
echo "${SSH_KEY_PASSWORD}" | ssh-add ~/.ssh/id_rsa

# echo "克隆仓库"
git clone git@github.com:aaaapai/android-openjdk-autobuild

# echo "拉取更新"
cd android-openjdk-autobuild
git pull
cd ..

# echo "检测环境变量 JRE_OUTPUT 是否已设置"
if [ -z "$JRE_OUTPUT" ]; then
    echo "Environment JRE_OUTPUT is not set."
    exit 1
else
    if [ "$JRE_OUTPUT" -eq 8 ]; then
        cp -rf JreOutPut/* android-openjdk-autobuild/LatestJre/jre-8/
    elif [ "$JRE_OUTPUT" -eq 11 ]; then
        cp -rf JreOutPut/* android-openjdk-autobuild/LatestJre/jre-11/
    elif [ "$JRE_OUTPUT" -eq 17 ]; then
        cp -rf JreOutPut/* android-openjdk-autobuild/LatestJre/jre-17/
    elif [ "$JRE_OUTPUT" -eq 21 ]; then
        cp -rf JreOutPut/* android-openjdk-autobuild/LatestJre/jre-21/
    elif [ "$JRE_OUTPUT" -eq 25 ]; then
        cp -rf JreOutPut/* android-openjdk-autobuild/LatestJre/jre-25/
    fi
fi


# echo "进入仓库目录"
cd android-openjdk-autobuild

# echo "提交更改"
git config --global user.email "${USER_EMAIL}"
git config --global user.name "${USER_NAME}"
git config --global --add safe.directory "*"
git add .
git commit -m "Push Jre"

# echo "推送更新"
git push
