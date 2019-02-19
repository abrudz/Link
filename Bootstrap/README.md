# How to bootstrap `Link`

In Dyalog APL versions before 17.1, `Link` must be manually added to the existing session (stored in a .dse file). There are two targets for easily doing so:

1. A *standard* 17.0 session, namely the .dse file installed with Dyalog APL.
1. A *clean* 17.0 session, in the sense that it does not use the `WorkspaceLoaded` event (it is normally used by SALT, the font and font-size selectors, and the "Boxing on/off" button), for example, because no session file was loaded at startup.

If you have a custom session, [see below](#installing-into-a-custom-session).

## General installation instructions

In the below, **[DYALOG]** refers to the 17.0 install directory.

1. Copy the **Link** directory's files into **[DYALOG]/Library/StartupSession/Link**
1. Copy **Link/Bootstrap/startup.dyalog** into **[DYALOG]**
1. `2⎕FIX'file://<path>/Link/Bootstrap/RemoveLinks.dyalog'`
1. Depending on target system:

   1. For a *standard* install: `2⎕FIX'file://<path>/Link/Bootstrap/WSLoaded-standard.dyalog'`
   2. For a *clean* install: `2⎕FIX'file://<path>/Link/Bootstrap/WSLoaded-clean.dyalog'`
1. `2⎕FIX'file://<path>/Link/Bootstrap/BUILD_DYALOGSPACE.dyalog'`
1. Run `BUILD_DYALOGSPACE`
1. Save the session

## Installing into a custom session

`Link` can still be enabled in a session which *does* use the `WorkspaceLoaded` event, but it is considerably more involved:

1. Follow steps 1 and 2 above.

1. Edit the callback function for the `WorkspaceLoaded` event (as reported by `{⊃1⌽l⊃⍨⍵⍳⍨1⊃¨l←'⎕SE'⎕WG'Event'}⊂'WorkspaceLoaded'`) to insert the following code at the very top (it must begin at line `[1]`) of the function:
```
 ;boot;Env
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
```
Also ensure that the function ends with:
```
 :If ×⎕NC'⎕SE.Link.WSLoaded'
     ⎕SE.Link.WSLoaded
 :EndIf
```
Be especially careful to catch all occurances of things like `→`, `→0`, `:GoTo 0`, `:Return` etc. and redirect them to reach the above code before the function terminates.
