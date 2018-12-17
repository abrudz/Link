 list←List ns;nss;within;count
 within←{           ⍝ nss within parent
     ⍺←0            ⍝ first level call
     r←⍺∨⍺⍺∊⍵       ⍝ well, is it?
     ∧/r:r          ⍝ they all are
     m←⍺⍺∊# ⎕SE ⎕DMX
     ∧/m:r          ⍝ we reached #
     i←⍸~m
     r[i]←r[i](⍺⍺[i].## ∇∇)⍵  ⍝ try parents
     r
 }
 :If ×≢⎕SE.Link.Links
     nss←2⊃¨5177⌶⍬
     count←{+/nss within⍎⍵}¨⎕SE.Link.Links.ns
     list←'Namespace' 'Directory' 'Names'
     list⍪←⎕SE.Link.Links.(↑ns dir),count
 :Else
     list←'No active links'
 :EndIf
