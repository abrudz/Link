 files←GetFileName items;table;⎕IO;itemlist;filelist;roots;this
 ⎕IO←0
 items←⊆,items
 items~¨←' '
 roots←(⍳∘'.'↑⊢)¨items
 this←'.',⍨⍕⊃⌽2⍴⎕RSI
 items,¨⍨←/∘this¨~roots∊,¨'#' '⎕SE' '⎕DMX'
 table←5177⌶⍬
 itemlist←{(⍕1⊃⍵),'.',⊃⍵}¨table
 filelist←(3⊃¨table),⊂''
 files←filelist[itemlist⍳items]
