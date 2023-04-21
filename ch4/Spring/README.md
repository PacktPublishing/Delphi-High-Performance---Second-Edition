![Spring4D medium.png](https://bitbucket.org/repo/jxX7Lj/images/3496466100-Spring4D%20medium.png)


Spring4D is an open-source code library for Embarcadero Delphi XE and higher.
It consists of a number of different modules that contain a base class library (common types, interface based collection types, reflection extensions) and a dependency injection framework. It uses the Apache License 2.0.

Installation
------------
Just run the Build.exe and select the Delphi versions you want to install Spring4D for.  
Alternatively open the project group in your IDE and compile the packages. Add the `Library\<delphiversion>\<config>` folder to your library path to access the precompiled units.

Current version
---------------
2.0 (tba)

Known issues
------------
* Compilation on XE6 and XE7 might fail spuriously. This seems to be related to some bug in the compiler with some non deterministic state.
* One unit test on XE2 and XE3 fails on Win64 because passing a method parameter is not handled properly by dynamic invokation.
* Some warnings when compiling for mobile compilers.
* The deployment of the unit test project might fail for mobile compilers (iOS ARM and Android).
* Compilation on some older versions for iOS and Android might fail due to compiler bugs.

Please support us
-----------------
[![btn_donate_LG.gif](https://bitbucket.org/repo/jxX7Lj/images/1283204942-btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=KG4H9QT3MSDN8)


Copyright (c) 2009 - 2023 Spring4D Team
