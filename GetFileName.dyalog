 files←GetFileName item;table;⎕IO;itemlist;filelist;roots;this;items
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
