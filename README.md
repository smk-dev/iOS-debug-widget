iOS-debug-widget
================

A simple way to display information at runtime while debuging your application.
It also displays your NSLogs so you can view them on the device when not connected to debugger.


How to use
================

1.Include the files in your project

2.Import "SMKDebugWidget.h" into your appdelegate

3.Call [SMKDebugWidget addToWindow:self.window] from within 'didFinishLaunchingWithOptions' (Optionaly call [SMKDebug enableLogging], see demo)

4.(Optional) import 'SMKDebugWidget.h' into classes where you would like NSLogs to display in widget
