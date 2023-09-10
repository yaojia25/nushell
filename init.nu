# ~/.config/nushell/init.nu
#
# 在启动时导出所需命令和环境变量
# 在config.nu 中添加source ~/.config/nushell/init.nu

let CUSTOM_CONFIG = ($env.HOMEPATH | path join '.config')

def has-env [...names] {
    $names | each {|n|
        $n in $env
    } | all {|i| $i == true}
}
let is_windows = ((sys).host.name | str downcase) == 'windows'
let path_name = (
    if (has-env 'Path') {
        'Path'
    } else {
        'PATH'
    }
)
# 快捷键
$env.keybindings = ($env.config.keybindings | merge [
    {
        name: vscode
        modifier: alt
        keycode: char_.
        mode: [emacs, vi_normal, vi_insert]
        event: [
          {
            send: executehostcommand,
            cmd: "code"
          }
        ]
    }
])
# Python环境变量
$env.config = ( $env.config | upsert hooks.env_change.PWD {
    [
        {
            condition: {|_, after|
                ($after | path join .venv Scripts activate.nu | path exists)
            }
            code: "overlay use .venv\\Scripts\\activate.nu"
        }
        # {
        #     condition: {|before, after|
        #         ($before | path join .venv | path exists)
        #         and ('activate' in (overlay list))
        #     }
        #     code: "deactivate"
        # }
    ]
})
# 环境变量配置
load-env {
    NU_LIB_DIRS: ( $CUSTOM_CONFIG | path join 'scripts' )
    BROWSER: "edge"
    EDITOR: "code"
    HOSTNAME:  (hostname | split row '.' | first | str trim)
    SHOW_USER: true
    LS_COLORS: (vivid generate dracula | str trim)
    # nushell 配置
    config: (
        $env.config | merge {
            show_banner: false
            footer_mode: 50
            keybindings: $env.keybindings
            # hooks: $env.python_venv
        }
    )
    # 环境变量 Path / Path 配置
    $path_name: ( $env | get $path_name |
        prepend 'C:\Users\yaojia\AppData\Local\Programs\Git\usr\bin'
    )
}

# Starship
if (which starship | is-empty) {
    return
} else {
    mkdir ~/.cache/starship
    starship init nu | save -f ~/.cache/starship/init.nu
    use ~/.cache/starship/init.nu
}

# def comps-use [name] {
#     use $"($CUSTOM_CONFIG) | path join )" *
# }
# 补全
# comps-use git-completions.nu
use ~/.config/nushell/completions/git-completions.nu *
use ~/.config/nushell/completions/pdm-completions.nu *
use ~/.config/nushell/completions/poetry-completions.nu *
# use ~/.config/nushell/completions/winget-completions.nu *

use ~/.config/nushell/scripts/adb-completions.nu *
use ~/.config/nushell/scripts/my-completions.nu *
# source ./alias.nu
source ./scripts/alias.nu

