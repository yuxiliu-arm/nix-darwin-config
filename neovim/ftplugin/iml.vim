" Activate merlin on current buffer
let b:merlin_path = trim(system("which ocamlmerlinlocal"))
call merlin#Register()
