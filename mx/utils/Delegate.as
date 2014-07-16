class mx.utils.Delegate {
   public static function create(t:Object, f:Function) : Function
   {
      var _f:Function = function():Void
      {
         var _na:Array = arguments.slice(2);
         f.apply(t, arguments.concat(_na));
      };
      return _f;
   }
}