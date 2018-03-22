package zygame.data;

import starling.events.EventDispatcher;

/**
 *  列表数据
 */
class ListData extends EventDispatcher {
    
    private var _array:Array<Dynamic>;


    public function new(arr:Array<Dynamic>){
        super();
        _array = arr;
    }

    public var length(get,never):Int;
    private function get_length():Int
    {
        return _array.length;
    }

    public var source(get,never):Array<Dynamic>;
    private function get_source():Array<Dynamic>
    {
        return _array;
    }

    public function at(i:Int):Dynamic{
        return _array[i];
    }

    public function updateAll():Void
    {

    }

    public function updateAt(i:Int):Void
    {
        
    }

    
}