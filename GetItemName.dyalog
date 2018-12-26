 items←GetItemName file;table;⎕IO;filelist;files;itemlist
 :If ~×⎕NC'⎕SE.Link.DEBUG'
     ⎕SE.Link.DEBUG←0
 :ElseIf ⎕SE.Link.DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf
 :Trap ⎕SE.Link.DEBUG↓0
     ⎕IO←0
     files←{∊1 ⎕NPARTS ⍵}¨⊆file
     table←5177⌶⍬
     filelist←{∊1 ⎕NPARTS 3⊃⍵}¨table
     itemlist←(2↑¨table),⊂'' ''
     items←itemlist[filelist⍳files]
     items←{(⍕1⊃⍵),(×≢⊃⍵)/'.',⊃⍵}¨items
     items←⊃⍣(1≥≡file)⊢items
 :Else
     ⎕SIGNAL⊂⎕DMX.(('EM'EM)('Message'Message))
 :EndTrap
