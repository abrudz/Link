 opts←DefaultOpts opts;Default
 Default←{(⊆⍺){0=⎕NC ⍺:⍎⍺,'←⍵'}¨⊆⍵}
 :With 'opts'⎕NS ⍬

     'watch'Default'both'

     'source' 'flatten' 'caseCode' 'forceExtensions' 'forceFilenames'Default 0

     'beforeWrite' 'beforeRead'Default''

     'codeExtensions'Default⊂'aplf' 'aplo' 'apln' 'aplc' 'apli' 'dyalog' 'apl' 'mipage'
     codeExtensions{⍵↓¨⍨⍺=1⊃¨⊆⍵}∘⊆⍨←'.'

     'typeExtensions'Default 0 2⍴0 ''
     typeExtensions{_←⍺
         _⍪←2 'apla'
         _⍪←3 'aplf'
         _⍪←4 'aplo'
         _⍪←9.1 'apln'
         _⍪←9.4 'aplc'
         _⍪←9.5 'apli'
         _}←⍬
     typeExtensions{⍺[∪⍳⍨⊣/⍺;]}←⍬
 :EndWith
