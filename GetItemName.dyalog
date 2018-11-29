 items←GetItemName file;table;⎕IO;filelist;files;itemlist
 ⎕IO←0
 files←{∊1 ⎕NPARTS ⍵}¨⊆file
 table←5177⌶⍬
 filelist←{∊1 ⎕NPARTS 3⊃⍵}¨table
 itemlist←(2↑¨table),⊂'' ''
 items←itemlist[filelist⍳files]
 items←{(⍕1⊃⍵),'.',⊃⍵}¨items
 items←⊃⍣(1≥≡file)⊢items
