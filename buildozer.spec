[app]
title = 罗小黑战记辟谣查询
package.name = luoxiaohei
package.domain = org.example
source.dir = .
source.include_exts = py,png,jpg,kv,atlas,ttf
version = 1.0.0
requirements = python3,kivy
orientation = portrait
osx.python_version = 3
osx.kivy_version = 2.1.0
fullscreen = 0

[buildozer]
log_level = 2
warn_on_root = 1

[android]
api = 30
minapi = 21
ndk = 25b
build_tools = 30.0.3
accept_sdk_license = True

# 直接指定系统 SDK 和 NDK 的绝对路径
android.sdk_path = /usr/local/lib/android/sdk
android.ndk_path = /usr/local/lib/android/sdk/ndk/25.2.9519653
