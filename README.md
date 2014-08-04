TSW-AddonUtils
==============
Utility classes for use in The Secret World addons


<YOUR_NAMESPACE>.AddonUtils.AddonUtils
--------------------------------------
Static class containing handy functions used as part of the development workflow and also common functions used in many addons.  To avoid namespace collisions when this library is used across multiple modules in TSW, this class must be placed under your module's namespace.  Copy the AddonUtils directory into your namespace directory and add your path to the class definition.
   
   
mx.utils.Delegate
-----------------
A more strictly typed version of the Delegate class, to satisfy strict compilers.  Will be superceded at runtime by previously loaded instance of mx.utils.Delegate, so do not add any features to this class.