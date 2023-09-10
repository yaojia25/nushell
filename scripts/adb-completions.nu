def "nu-complete adb" [] {
    [
        ['value' 'description'];
        [install 安装应用]
        [shell 进入设备shell]
        [push 推送文件]
        [pull 拉取文件]
        [reboot 重启]
        [kill-server 停止adb服务]
    ]
}

# 操作指定设备
def "nu-complete adb devices" [] {
    adb devices -l
    | lines
    | where $it =~ 'model'
    # | str replace '\tdevice' ''
    # | parse "{value} {description}"
    | str trim
    | parse --regex '(?P<value>\w+)\s*device\s*(?P<description>product.+)'
    | str trim
}

def "nu-complete adb reboot" [] {
    [
        ['value' 'description'];
        ['bootloader' '重启进入bootloader模式']
        ['fastboot' '重启进入FastBoot模式']
        ['recovery' '重启进入recovery模式']
        ['edl' '重启进入edl模式']
    ]
}

def "nu-complete adb shell" [] {
    [ls, ps, top]
}


# 基础命令
export extern "adb" [
    -s: string@"nu-complete adb devices" # 指定连接设备
    command?: string@"nu-complete adb"
]


# 设备重启
export extern "adb reboot" [
    mode?: string@"nu-complete adb reboot"
]

# 查看已连接设备列表
export extern "adb devices" [
    -l # 显示更多信息
]

# 安装应用
export extern "adb install" [
    -r # 重新安装现有应用，并保留其数据
    -t # 允许安装测试 APK
    -d # 允许版本代码降级
    -g # 授予应用清单中列出的所有权限
    package: path # apk安装包路径
]

# 进入设备 shell
export extern "adb shell" [
    cmmand?: string@"nu-complete adb shell"
]

# 抓取日志
export extern "adb logcat" [
    -c: bool # 清除日志
]

