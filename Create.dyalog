 msg←{opts}Create(ns dir);Default;isWin;container;z;links;Qt;doNs;doDir;fsw;ix;linkDef;outFail;inFail

 msg←⍕⍬⊤⍬
 ns←⍕ns
 DefaultOpts'opts'⎕NS ⍬

 '⎕SE.Link'⎕NS ⍬
 :If 0=⎕NC'⎕SE.Link.Links'    ⍝ Check existence of our data structure
     ⎕SE.Link.Links←⍬         ⍝ Start with no links
 ⍝ Link namespaces will record switch values
 ⍝    and also contain fsw, the FileSystemWatcher object
 :EndIf

 isWin←'Windows'≡7↑⊃'.'⎕WG'APLVersion'
 :If ~isWin
 :AndIf (⊂opts.watch)∊'both' 'dir'
     msg←'Watching directories is only supported under Microsoft Windows'
 :Else
     container←⊃⌽2⍴⎕RSI    ⍝ ns is relative to where we were called from
     :If (ns≡,'#')⍱9.1=container.⎕NC⊂,ns ⍝ must be normal namespace
         msg←ns,' is not a namespace'
     :Else
         ns←container⍎ns
         :Trap 0
             z←(⊂'#.')~⍨{((⍸⍵='.')↑¨⊂⍵),⊂⍵}ns
             z←(0=container.⎕NC z)/z
             z container.⎕NS¨⊂''
             ns←container⍎ns
         :Else
             ns←0
         :EndTrap
         :If 0≡ns
             msg←'Unable to create: ',⍕ns
         :Else
             links←⎕SE.Link.Links
             :If 0<≢l
             :AndIf (⊂ns)∊⍎¨links.ns
                 msg←'A link already exists for: ',⍕ns
             :Else
                 :If ~⎕NEXISTS dir←U.Normalise 2⊃Input.Arguments
                 :AndIf ~3 ⎕MKDIR dir
                     msg←'Directory not found: ',dir
                 :Else
                     :If 0≡opts.source
                     :AndIf ∧/0≠(≢ns.⎕NL-⍳10),≢⊃(⎕NINFO⍠1)dir,'/*'
                         msg←'Source must be specified when linking a non-empty namespace to a non-empty directory'
                     :Else
                         :If opts.(flatten∧source≢'dir')
                             msg←'flatten≡1 requires source≡''dir'''
                         :Else
                             doNs←'ns' 'both'
                             doDir←'dir' 'both'
                             msg←⊂(⍕ns),' linked to ',dir
                             inFail←outFail←fsw←⍬
                             ix←'[',(⍕1+≢links),']'

                             :If opts.source∊doNs
                                 :If 0≠≢outFail←opts Export ns dir
                                     msg,←('Failed to export ',(⍕≢outFail),' file(s) - see:')('      ⎕SE.Link.Links',ix,'.outFail')
                                 :EndIf
                             :EndIf

                             :If opts.source∊doDir
                                 (inFail fsw)←opts Import ns dir
                                 :If 0≠≢inFail
                                     msg,←('Failed to import ',(⍕≢inFail),' file(s) - see:')('      ⎕SE.Link.Links',ix,'.inFail')
                                 :EndIf
                             :EndIf

                             linkDef←⎕SE.⎕NS opts
                             linkDef.⎕DF'[Link]'
                             ns←⍕ns
                             'linkDef'⎕NS'ns' 'dir' 'inFail' 'outFail'
                             ⎕SE.Link.Links,←linkDef
                             r←↑r
                         :EndIf
                     :EndIf
                 :EndIf
             :EndIf
         :EndIf
     :EndIf
 :EndIf
