 Bootstrap dir
 :If 0=⍴dir
     :If 'Win'≡3↑⊃# ⎕WG'APLVersion'
         dir←(⊢↓⍨1-'\'⍳⍨⌽)2⊃4070⌶⍬
     :Else
         dir←'/',⍨2 ⎕NQ #'GetEnvironment' 'HOME'
     :EndIf
     dir,←'Link/'
 :EndIf
 dir↓⍨←-'/\'∊⍨⊃⌽dir
 2 ⎕SE.(((⍎⎕NS∘⍬⊣⎕EX)'Link').⎕FIX)¨'file://'∘,¨⊃⎕NINFO⍠1⊢dir,'/*.apl?'
