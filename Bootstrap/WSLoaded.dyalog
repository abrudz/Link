 WSLoaded msg;Env;boot
⍝ Handle )LOAD and )CLEAR

⍝ To determine if the session just started we use ⎕AI
⍝ Keyboard time will be 0 the 1st time it is loaded but this will
⍝ be wrong in runtimes so we'll use the elapsed time there, assuming
⍝ that 15 seconds is enough to start APL.
⍝ In the worst case, if another ws is )LOADed within 15 sec of startup
⍝ initialisation will happen again.
⍝ timeout:  keying  connect
 boot←⎕AI{⎕IO←1 ⋄ ⍵:0=4⊃⍺ ⋄ 15000≥3⊃⍺}'Development'≡4⊃# ⎕WG'APLVersion'
 :If boot ⍝ These things need to be done once at Dyalog startup, not on subsequent WSLoaded events:
     Env←{2 ⎕NQ #'GetEnvironment'⍵}
     :Trap 0
         (⎕NS ⍬).(⍎⎕FX)⊃⎕NGET({×≢⍵:⍵ ⋄ '/startup.dyalog',⍨Env'DYALOG'}Env'DYALOGSTARTUP')1
     :Else
         ⍞←↑⎕DMX.(Message∘{⍵,⍺,⍨': '/⍨×≢⍺}¨@1⊢DM)
         ⎕DL 3
         ⎕OFF
     :EndTrap
 :EndIf

 ⍝ The rest also need to be done on every )CLEAR or )LOAD:
 RemoveLinks
