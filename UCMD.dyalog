﻿    :Namespace UCMD
        ∇ r←Run(Cmd Input);U;argcount;container;dir;doDir;doNs;extn;flatten;fsw;infail;isWin;ix;l;linkDef;m;make;ns;onRead;onWrite;outfail;p;protect;quiet;reset;source;w;watch;z
          :Select Cmd
          :Case 'Link'
              U←##.Utils
         
              :If 0=⎕NC'⎕SE.Link.Links'    ⍝ Check existence of our data structure
                  ⎕SE.Link.Links←⍬         ⍝ Start with no links
              ⍝ Link namespaces will record switch values
              ⍝    and also contain fsw, the FileSystemWatcher object
              :EndIf
         
              (source protect make)←⊂¨'both'∘Input.Switch¨'source' 'protect' 'make'
              isWin←'Windows'≡7↑⊃'.'⎕WG'APLVersion'
              watch←⊂((1+isWin)⊃'ns' 'both')∘Input.Switch'watch' ⍝ Default to "both" under Windows, else "ns"
              protect←⊂'none'Input.Switch'protect' ⍝ /// while protect is not supported
              extn←'.dyalog'Input.Switch'extn'     ⍝ File extension to use
              flatten←0 Input.Switch'flatten'      ⍝ Whether to flatten the external folder structure
              quiet←~0 Input.Switch'prompt'        ⍝ do not prompt on external changes?
              reset←0 Input.Switch'reset'          ⍝ Kill all links
         
              (onRead onWrite)←''∘Input.Switch¨'onRead' 'onWrite'
         
              :If ~isWin
              :AndIf (⊂watch)∊'both' 'dir'
                  →0⊣r←'Watching directories is only supported under Microsoft Windows'
              :EndIf
         
              :If protect≢⊂'none'
                  →0⊣r←'-protect not yet supported'
              :EndIf
         
              ns←⊃Input.Arguments
              :If 0≠argcount←≢Input.Arguments    ⍝ ns provided
                  container←⎕RSI⊃⍨⎕SI⍳⊂'UCMD'    ⍝ ns is relative to where we were called from
         
                  :If (ns≡,'#')∨9=container.⎕NC ns
                      ns←container⍎ns
                  :ElseIf make∊'ns' 'both'
                      :Trap 0
                          z←(⊂'#.')~⍨{((⍸⍵='.')↑¨⊂⍵),⊂⍵}ns
                          z←(0=container.⎕NC z)/z
                          z container.⎕NS¨⊂''
                          ns←container⍎ns
                      :Else
                          →0⊣r←'Unable to create: ',ns
                      :EndTrap
                  :Else
                      →0⊣r←ns,' is not a namespace'
                  :EndIf
              :EndIf
         
              l←⎕SE.Link.Links
              :If 1=argcount     ⍝ only ns provided
                  :If 0=≢l
                  :OrIf 1≠⍴l←((⍎¨l.ns)∊ns)/l          ⍝ reduce l
                      →0⊣r←'No link defined for namespace ',ns
                  :EndIf
              :EndIf
         
              :Select argcount
              :CaseList 0 1 ⍝ ns only provided, or nothing: Report or Reset
                  :If reset
                      :If argcount=0
                          :If 0=⍴⎕SE.Link.Links ⋄ r←'Nothing to reset'
                          :Else ⋄ r←⍪ResetLink¨l
                          :EndIf
                      :ElseIf argcount≠1 ⋄ r←'-reset requires selection of a namespace'
                      :Else ⋄ r←ResetLink ⍬⍴l
                      :EndIf
                      →0
                  :Else
                      →0⊣r←ReportLinks l
                  :EndIf
              :Case 2       ⍝ ns and dir: Create a link
                  :If 0<≢l
                  :AndIf (⊂ns)∊⍎¨l.ns
                      →0⊣r←↑('A link already exists for ',(⍕ns),'- please use:')('      ]link ',(⍕ns),' -reset')
                  :EndIf
         
                  :If ~⎕NEXISTS dir←U.Normalise 2⊃Input.Arguments
                      :If make∊'dir' 'both'
                          3 ⎕MKDIR dir
                      :Else
                          →0⊣r←'Directory not found: ',dir
                      :EndIf
                  :EndIf
         
                  :If 0≡Input.Switch'source'
                  :AndIf ∧/0≠(≢ns.⎕NL⍳10),≢⊃(⎕NINFO⍠1)dir,'/*'
                      →0⊣r←'-source must be specified when linking a non-empty namespace to a non-empty folder'
                  :EndIf
         
              :Else
                  'requires one or two arguments: [ns [dir]]'⎕SIGNAL 11
              :EndSelect
         
              '-flatten requires -source=dir'⎕SIGNAL(flatten∧source≢⊂'dir')/11 ⍝ cannot export and flatten
         
              doNs←'ns' 'both'
              doDir←'dir' 'both'
              r←⊂(⍕ns),' linked to ',dir
              infail←outfail←fsw←⍬
              ix←'[',(⍕1+≢⎕SE.Link.Links),']'
         
              :If source∊doNs
                  (p m)←protect make∊¨⊂doDir
                  w←watch∊doNs
                  :If 0≠≢outfail←ns Export dir p w m extn flatten quiet
                      r,←('Failed to export ',(⍕≢outfail),' file(s) - see:')('      ⎕SE.Link.Links',ix,'.outfail')
                  :EndIf
              :EndIf
         
              :If source∊doDir
                  (p m)←protect make∊¨⊂doNs
                  w←watch∊doDir
                  (infail fsw)←ns Import dir p w m extn flatten quiet
                  :If 0≠≢infail
                      r,←('Failed to import ',(⍕≢infail),' file(s) - see:')('      ⎕SE.Link.Links',ix,'.infail')
                  :EndIf
              :EndIf
         
              (linkDef←⎕SE.⎕NS ⍬).⎕DF'[Link]'
              linkDef.(ns dir extn flatten protect watch fsw infail outfail)←((⍕ns)dir extn flatten protect watch fsw infail outfail)
              linkDef.(onWrite onRead quiet)←onWrite onRead quiet
              ⎕SE.Link.Links,←linkDef
         
              r←⍕⍪r
          :EndSelect
        ∇
        ∇ r←ResetLink link;m;ol;i;name;ns;n
     ⍝ Reset a link
         
          ol←objectLinks ⍬
          m←⍸(2⊃¨ol)within⍎link.ns
          m←m[⍋3⊃¨ol[m]] ⍝ members first, classes last
         
          :For i :In m
              (name ns)←2↑i⊃ol
              {}5178(ns.⌶)⍕name ⍝ break ⎕FIX linkage
          :EndFor
         
          :If 9=⎕NC'link.fsw'
              link.fsw.Object.EnableRaisingEvents←0
          :EndIf
         
          ⎕SE.Link.Links~←link
          r←'Link from ',(⍕link.ns),' to ',(⍕link.dir),' removed (',(⍕≢m),' names affected)'
        ∇
        ∇ r←ReportLinks links;count
          :If 0=≢links
              →0⊣⊂r←'No source links defined'
          :EndIf
         
          count←+/¨((2⊃¨objectLinks ⍬)within)¨⍎¨l.ns
         
          r←⊂'Namespace' 'Directory' 'Names'⍪(↑l.(ns dir)),count
          r←⍕⍪r
        ∇
          within←{           ⍝ nss within parent
              ⍺←0            ⍝ first level call
              r←⍺∨⍺⍺∊⍵       ⍝ well, is it?
              ∧/r:r          ⍝ they all are
              m←⍺⍺∊# ⎕SE
              ∧/m:r          ⍝ we reached #
              i←⍸~m
              r[i]←r[i](⍺⍺[i].## ∇∇)⍵  ⍝ try parents
              r
          }
        objectLinks←5177⌶
          Import←{ ⍝ Load items from files in folders
              ⍺←#                                      ⍝ default is root
              target←⍺                                 ⍝ left arg is namespace to put items in
              (source protect watch make extn flatten quiet)←⍵ ⍝ right arg is where to load from, check for existing, break connection
              detach←~watch                            ⍝ if we don't need to watch, simply detach
     ⍝disperse←1
         
              Slash←∊∘'/\'                             ⍝ Mark slashes
              Parts←~∘Slash⊆⊢                          ⍝ Path parts
         
              source↓⍨←-Slash⊃⌽source                  ⍝ Remove slash from end
              cands←⊃⎕NINFO⍠1⊢source,'*'               ⍝ normalised source candidates
              candLengths←≢¨cands                      ⍝ their lengths
         
              3::(⍵~0)⍬                               ⍝ if unlisted
         
              source←cands⊃⍨candLengths⍳≢source        ⍝ first length-match
              name←⊃⌽Parts source                      ⍝ name without path
     ⍝~disperse:source protect detach 1 ∇⍨⍎name ⍺.⎕NS ⍬ ⍝ adjust level and call again
         
              File←detach{⍺⍺:⊃⎕NGET ⍵ 1 ⋄ 'file://',⍵} ⍝ Prepare file by getting source or prepending prefix
         
              2≡1 ⎕NINFO source:watch{ ⍝ if it is a file, just fix it
                  _←2 target.⎕FIX File ⍵
                  ~⍺:⍬ ⍬
                  d f e←⎕NPARTS ⍵
                  ⍬(##.FileSystemWatcher.Watch d(f,e))
              }source
              source,←'/'                              ⍝ append missing slash
              list←0 1 6 ⎕NINFO⍠1⍠'Recurse' 1⊢source,'*' ⍝ recursive listing of everything
         
              Where←⌿⍨                                 ⍝ Filter as function
              Begins←⊃⍷                                ⍝ ⍵ starts with ⍺
         
              hideBit←1=3⊃list                         ⍝ mask for hidden items
              hidden←⊃list Where¨⊂hideBit              ⍝ list of hidden (files and) folders
              hidden,¨←'/'                             ⍝ protect agains similarly named items
              list←list Where¨⊂~hideBit                ⍝ keep only visible items
              list←list Where¨⊂~∨⌿hidden∘.Begins⊃list  ⍝ filter away things that come below hidden things
              list↓⍨←¯1                                ⍝ remove hideBit column
         
              RightExtn←extn≡(-≢extn)↑⊢                ⍝ Ends with specified extension?
         
              Files←⊢Where RightExtn¨                  ⍝ Those that end with specified extension
         
              files←Files⊃list                         ⍝ first column is filename
              dirs←⊃Where/1=@2⊢list                    ⍝ second column has 1 for dirs
              dirs,¨←'/'                               ⍝ give the dirs trailing slashes
              list←dirs⍪files                          ⍝ we need to process dirs before files
              (beyondUCS slashUCS)←1114112 47          ⍝ we treat / as if after all UCS chars
              order←⍋beyondUCS@(slashUCS=⊢)↑⎕UCS¨list  ⍝ order slashes after all chars
              list←list[order]                         ⍝ sort the list
         
              Path←⊢↓⍨∘-'/'⍳⍨⌽                         ⍝ Until last slash
              RemDir←(≢source)∘↓                       ⍝ Only path beginning at target source
         
              paths←∪RemDir∘Path¨list                  ⍝ paths of all unique items
              paths~←⊂''                               ⍝ remove empty
         
              Nss←,\'.',¨1↓Parts                       ⍝ Convert file path to ns path
              DotSlash←'.'@Slash                       ⍝ Convert dots to slashes
         
              _←{⍵:⍬                                   ⍝ If we are not flattening, create nss
                  nss←DotSlash¨paths                   ⍝ all necessary namespaces
                  nss←(¯1≠⎕NC nss)/nss                 ⍝ ignore invalid names
                  NsExpr←'''',,∘'''⎕NS⍬'               ⍝ Expression to create namespace
                  target.⍎∘NsExpr¨nss                  ⍝ create namespaces in target
              }flatten
         
              PadThis←⊢,'⎕THIS'/⍨0=≢                   ⍝ Default path to here
              Target←DotSlash∘PadThis∘((~flatten)∘/)Path∘RemDir ⍝ Determine target path
         
              FixThere←{ ⍝ Fix the file ⍵ in the namespace ⍺
                  t←(1+flatten)⊃(⍺.⍎Target ⍵)⍺         ⍝ final target
                  2 t.⎕FIX File ⍵ ⍝ do it
              }
         
              TryFixThere←{      ⍝ Try to fix file there
                  ⍵∧.=' ':⍬      ⍝ Called by each on prototype: ignore
                  6 11::⍵        ⍝ return name on failure
                  0⊣⍺ FixThere ⍵ ⍝ do it and return 0 on success
              }
         
              r←0~⍨target∘TryFixThere¨Files list ⍝ try it and return only failures
     ⍝ return (list of failures) and (watcher reference or zilde)
              r({⍵:##.FileSystemWatcher.Watch(¯1↓source)(,'*') ⋄ ⍬}watch)
          }
          Export←{ ⍝ Write items to file in folders
         
              ⍺←#                           ⍝ default is root
              source←⍺                      ⍝ left arg is namespace get items from
              (dir protect watch make extn flatten quiet)←⍵ ⍝ right arg is where to store files and whether to protect
              overwrite←~protect            ⍝ make positive
              dir,←'/'/⍨~'/\'∊⍨⊃⌽dir        ⍝ append trailing slash if missing
              dir←⊃1 ⎕NPARTS dir            ⍝ normalise ─ '' means current dir
         
              Enclose←⊢ ⍝ ,¨@1,⊣            ⍝ Add ∇s to ⎕NR
              Path←dir,'/'⊣@('.'=⊢)⊢        ⍝ Ns path → full path
              Path←Path,'/'extn⊃⍨⊣      ⍝ Append appropriate tail (⍺=1:dir; ⍺=2:file)
              Into←overwrite{ ⍝ Put vtv into file
                  22::⍵                  ⍝ no file access
                  _←3 ⎕MKDIR⊃1 ⎕NPARTS ⍵ ⍝ create dir if needed
                  0⊣⍵ ⍺⍺ ⎕NPUT⍨⊂⍺        ⍝ overwrite
              }
              AbsDelRep←'∇'Enclose ⎕NR  ⍝ Put ∇s on ⎕NR
              Last←⊢↑⍨1-'.'⍳⍨⌽          ⍝ Item name without ns path
              AbsSaveFn←AbsDelRep Into 2 Path Last ⍝ Save single fn into target
         
              ''≡0⍴⍺:0⍴⊂0⍴AbsSaveFn source ⍝ single fn/op
         
              OnEach←{ ⍝ ¨ without prototype call on empty
                  0∊⍴⍵:⍬ ⍝ if empty return empty
                  ⍺←⊢    ⍝ ambivalent
                  ⍺ ⍺⍺¨⍵ ⍝ call
              }
         
              SaveNs←{ ⍝ Save namespace whether scripted or not
                  0=≡⍵:0                ⍝ prototype means
                  16::0 ⍵               ⍝ problem: no script
                  src←⎕SRC source.⍎⍵    ⍝ get source from its location
                  22::⍵ 0               ⍝ failed: no file access
                  0 0⊣src Into 2∘Path ⍵ ⍝ save as namespace and report OK
              }
         
              nss←source.⎕NL ¯9.1 ¯9.4 ¯9.5              ⍝ namespaces
         
              No0←~∘0                                    ⍝ Remove fills
              DelRep←'∇'Enclose source.⎕NR               ⍝ ⎕NR with ∇s there
              SaveFn←DelRep Into 2∘Path                  ⍝ Save function there
         
              failed unscripted←No0¨↓⍉↑SaveNs OnEach nss ⍝ go through them
              paths←1∘Path¨unscripted                    ⍝ needed dirs
              _←3 ⎕MKDIR paths                           ⍝ make them if they don't exist
              ok←⎕NEXISTS paths                          ⍝ did it work?
              fns←source.⎕NL-3.1 3.2 4.1 4.2             ⍝ tradfn, dfn, tradop, dop
              failed,←No0 SaveFn OnEach fns              ⍝ try to save the functions
              failed,←paths/⍨~ok                         ⍝ also remember failed paths for nss
              paths/⍨←ok                                 ⍝ the good paths
              unscripted/⍨←ok                            ⍝ and their namespaces
         
              Ref←source.⍎⊣                              ⍝ Translate text larg to ref
              Recurse←Ref ∇ protect watch make extn flatten quiet,⍨⊢∘⊂ ⍝ How to call into subs
         
              failed,⊃,/unscripted Recurse OnEach paths  ⍝ recurse and collect failures
          }
    :EndNamespace
