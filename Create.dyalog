 {count}←{opts}Create(ns dir);Default
 Default←(⍎'opts'⎕NS ⍬){0=⍺⍺.⎕NC ⍺:⍺⍺⍎⍺,'←⍵'}

 'source' 'watch'Default¨⊂'both'
 'flatten' 'caseCode' 'forceExtensions' 'forceFilenames'Default¨0
 'codeExtensions'Default'aplf' 'aplo' 'apln' 'aplc' 'apli' 'dyalog' 'apl' 'mipage'
 'beforeWrite' 'beforeRead'Default''
 'typeExtensions'Default 0 2⍴0 ''
 opts.typeExtensions{_←⍺
     _⍪←2 'apla'
     _⍪←3 'aplf'
     _⍪←4 'aplo'
     _⍪←9.1 'apln'
     _⍪←9.4 'aplc'
     _⍪←9.5 'apli'
     _}←⍬
