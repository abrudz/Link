 name←CaseCode name;bin;len;digits;⎕IO
 ⎕IO←0
 bin←name≠819⌶name
 len←⌈3÷⍨≢bin
 digits←2⊥⌽⍉⌽len 3⍴bin↑⍨3×len
 digits↓⍨←+/∧\0=digits
 name,←'-',⎕D[digits,0/⍨⍬≡digits]
