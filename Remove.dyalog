 msg←Remove items;SplitName;roots;this;table;itemlist;filelist;files;mask
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
