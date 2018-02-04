let s:cfg_files = globpath($VIMHOME . '/conf.d/plugins/', '*.vim', 0, 1)
for plugincfg in s:cfg_files
    execute 'source ' . plugincfg
endfor
