function g
  git
end

function ga
  'git add'
end

function gcam
  'git commit -a -m'
end

function gd
  'git diff'
end

function glog
  'git log --oneline --decorate --graph'
end

function gp
  'git push'
end

function gst
  'git status'
end

function l
  '/nix/store/5gsbcdz2x12bh5cn7dmm6nwgzayi5k2r-exa-0.10.1/bin/exa -lbF --git --group-directories-first --icons'
end

function la
  '/nix/store/5gsbcdz2x12bh5cn7dmm6nwgzayi5k2r-exa-0.10.1/bin/exa -lbhHigmuSa --time-style=long-iso --git --color-scale --group-directories-first --icons'
end

function ll
  '/nix/store/5gsbcdz2x12bh5cn7dmm6nwgzayi5k2r-exa-0.10.1/bin/exa -lbF --git --group-directories-first --icons'
end

function llm
  '/nix/store/5gsbcdz2x12bh5cn7dmm6nwgzayi5k2r-exa-0.10.1/bin/exa -lbGd --git --sort=modified --group-directories-first --icons'
end

function ls
  '/nix/store/5gsbcdz2x12bh5cn7dmm6nwgzayi5k2r-exa-0.10.1/bin/exa --group-directories-first'
end

function lt
  '/nix/store/5gsbcdz2x12bh5cn7dmm6nwgzayi5k2r-exa-0.10.1/bin/exa --tree --level=2 --group-directories-first --icons'
end

function lx
  '/nix/store/5gsbcdz2x12bh5cn7dmm6nwgzayi5k2r-exa-0.10.1/bin/exa -lbhHigmuSa@ --time-style=long-iso --git --color-scale --group-directories-first --icons'
end

function update
  'sudo nixos-rebuild switch'
end
