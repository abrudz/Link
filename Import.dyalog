 msg←Import(ns path);opts
 opts←⎕NS ⍬
 opts.watch←'none'
 opts.source←'dir'
 opts FixFiles ns path
