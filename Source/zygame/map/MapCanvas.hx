package zygame.map;

import starling.display.Canvas;
import zygame.display.World;

/**
 *  绘制出的图形
 */
class MapCanvas extends Canvas {
    
    public var mode:String;

    public var world:World;

    public function new(mode:String)
    {
        super();
        this.mode = mode;
    }

}