def "nu-complete venv" [] {
    let venv_name = (ls | where type == dir | get name | where $it =~ venv)
    if ($venv_name | is-empty) { null } else { $venv_name | path join 'Scripts' 'activate.nu' | uniq }

}

# custom overlay use
# export def "py use" [
#     venv: string@"nu-complete venv"
#     # path?: path
# ]


