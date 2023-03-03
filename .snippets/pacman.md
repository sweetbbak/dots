## Pacman

# what packages are installed
pacman -Q gtk{2,3,4}
# requires pacman contrib check which package uses another with a tree
eval 'pactree -r gtk'{2,3,4}';'
