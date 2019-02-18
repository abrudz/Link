# How to bootstrap `Link`

In Dyalog APL versions before 17.1, `Link` must be manually added to the existing session. There are two targets for doing so:

1. A *standard* install of 17.0.
1. A 17.0 install which is *clean* in the sense that it does not use the `WorkspaceLoaded` event (it is normally used by SALT, the font and font-size selectors, and the "Boxing on/off" button).

## Instructions

In the below, **[DYALOG]** refers to the 17.0 install directory.

1. Copy the **Link** directory's files into **[DYALOG]/Library/StartupSession/Link**
1. Copy **Link/Bootstrap/startup.dyalog** into **[DYALOG]**
1. `2⎕FIX'file://<path>/Link/Bootstrap/BUILD_DYALOGSPACE.dyalog'`
1. `2⎕FIX'file://<path>/Link/Bootstrap/RemoveLinks.dyalog'`
1. Depending on target system:

   1. For a *standard* install: `2⎕FIX'file://<path>/Link/Bootstrap/WSLoaded-standard.dyalog'`
   2. For a *clean* install: `2⎕FIX'file://<path>/Link/Bootstrap/WSLoaded-clean.dyalog'`
1. Run `BUILD_DYALOGSPACE`
1. Save the session
