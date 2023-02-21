function l --wraps='exa -G --icons --directories-first -1' --wraps='exa -G --icons -1' --description 'alias l=exa -G --icons -1'
  exa -G --icons -1 $argv
        
end
