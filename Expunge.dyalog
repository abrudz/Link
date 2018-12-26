 {r}←Expunge names
⍝ Use in place of ⎕EX for linked names - will expunge source files where relevant

 :If ×⎕NC'DEBUG'
 :AndIf DEBUG=2
     (1+⊃⎕LC)⎕STOP⊃⎕SI
 :EndIf

 r←(⊃⎕RSI){
     src←Utils.GetLinkInfo caller ⍵
     r←⍺.⎕EX name

     del←(0≢4⊃src)∧0=≢4⊃Utils.GetLinkInfo ⍺ ⍵ ⍝ There was source and now there is none
     r⊣⎕NDELETE⍣del⊢4⊃src
 }¨⊆names
