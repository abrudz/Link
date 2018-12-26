 msg←Remove items;SplitName;roots;this;table;itemlist;filelist;files;mask
 :If ~×⎕NC'⎕SE.Link.DEBUG'
     ⎕SE.Link.DEBUG←0
 :ElseIf ⎕SE.Link.DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf
 :Trap ⎕SE.Link.DEBUG↓0

     :If ×≢items
         items←⊆,items
         items~¨←' '
         roots←{⍵↑⍨⍵⍳'.'}¨items
         this←'.',⍨⍕⊃⌽2⍴⎕RSI
         items,¨⍨←/∘this¨~roots∊,¨'#' '⎕SE' '⎕DMX'
         table←5177⌶⍬
         itemlist←{(⍕1⊃⍵),'.',⊃⍵}¨table
         filelist←(3⊃¨table),⊂''
         mask←items∊itemlist
         files←filelist[itemlist⍳mask/items]
         1 ⎕NDELETE files
         ⎕EX items
         msg←⊂'Removed:',∊' ',¨items
         :If 0∊mask
             msg,←⊂'Not linked:',∊' ',items/⍨~mask
         :EndIf
     :EndIf
 :Else
     ⎕SIGNAL⊂⎕DMX.(('EM'EM)('Message'Message))
 :EndTrap
