 files←GetFileName item;table;⎕IO;itemlist;filelist;roots;this;items
 :If ~×⎕NC'⎕SE.Link.DEBUG'
     ⎕SE.Link.DEBUG←0
 :ElseIf ⎕SE.Link.DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf
 :Trap ⎕SE.Link.DEBUG↓0
     ⎕IO←0
     items←⊆,item
     items~¨←' '
     roots←(⍳∘'.'↑⊢)¨items
     this←'.',⍨⍕⊃⌽2⍴⎕RSI
     items,¨⍨←/∘this¨~roots∊,¨'#' '⎕SE' '⎕DMX'
     table←5177⌶⍬
     itemlist←{(⍕1⊃⍵),'.',⊃⍵}¨table
     filelist←(3⊃¨table),⊂''
     files←⊃⍣(1≥≡item)⊢filelist[itemlist⍳items]
 :Else
     ⎕SIGNAL⊂⎕DMX.(('EM'EM)('Message'Message))
 :EndTrap
