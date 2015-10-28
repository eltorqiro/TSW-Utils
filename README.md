TSW-AddonUtils
==============
Utility classes for use in The Secret World addons
  
  
When using any of these classes, you must ensure namespace isolation within each of your projects.  This is done by copying the AddonUtils folder into your application's source tree, and then doing a _find & replace_ operation on it to replace the text `__ProjectNamespace__` with your project's namespace.

For example, if you copied AddonUtils into com/mydomain/project/AddonUtils then find & replace `__ProjectNamespace__` with `com.mydomain.project`
  
  
.AddonUtils.*
-------------
Classes containing both boilerplate and utility functionallity used as part of the development workflow for common addon internals such as user preferences, VTIO registration, etc.
   
   
.AddonUtils.GuiEditMode.*
-------------------------
Provides a common interface for managing clips under Gui Edit Mode (gem), without having to place significant gem handling or awareness into project components.
  
  
.AddonUtils.UI.*
----------------
User Interface components covering a range of common UI elements.  Includes a PanelBuilder class, which enables configuration interfaces to be built dynamically at runtime using a definition object, rather than code.
