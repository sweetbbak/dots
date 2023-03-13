typeset -U path PATH

# bins
path=(~/.local/bin ~/bin ~/.cargo/bin ~/go/bin ~/dev/bin $path)
# language bins
path=(~/.luarocks/bin ~/node_modules/.bin $path)
# script dirs
path=(~/scripts ~/scripts/fzf-bin ~/src ~/dev ~/dev/bin $path)
# appimages and apps
path=(~/apps ~/apps/blender340 $path) 

path+=(~/bin/**/*(N/))
# get dirs at 1 depth in bin
# dirs=$( fd . $HOME/bin/ -t d -d 1 )

# path=("$dirs")

# for dir in ~/bin ~/dev; do
# if [[ -z ${path[(r)$dir]} ]]; then
  # path=($dir $path)
# fi 
# done

export PATH
