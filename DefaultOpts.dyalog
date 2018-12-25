 {opts}←DefaultOpts opts;Default
 'opts'⎕NS ⍬
 Default←opts.{(⊆⍺){0=⎕NC ⍺:⍎⍺,'←⍵'}¨⊆⍵}

 'watch' 'source'Default'both'

 'flatten' 'caseCode' 'forceExtensions' 'forceFilenames'Default 0

 'beforeWrite' 'beforeRead'Default''

 'codeExtensions'Default⊂'aplf' 'aplo' 'apln' 'aplc' 'apli' 'dyalog' 'apl' 'mipage'
 opts.codeExtensions{⍵↓¨⍨⍺=1⊃¨⊆⍵}∘⊆⍨←'.'

 'typeExtensions'Default 0 2⍴0 ''
 opts.typeExtensions{_←⍺
     _⍪←2 'apla'
     _⍪←3 'aplf'
     _⍪←4 'aplo'
     _⍪←9.1 'apln'
     _⍪←9.4 'aplc'
     _⍪←9.5 'apli'
     _}←⍬
 opts.typeExtensions{⍺[∪⍳⍨⊣/⍺;]}←⍬