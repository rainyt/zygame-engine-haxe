package zygame.utils;

import nape.geom.Vec2;

/**
	 * Nape引擎工具
	 * @author grtf
	 * 
	 */
class NapeUtils
{
    /** 解析出坐标列表 */
    public static function parsingPoint(data : String) : Array<Vec2>
    {
        var v : Array<Vec2> = new Array<Vec2>();
        var arr : Array<Dynamic> = data.split(" ");
        var i : Int = 0;
        while (i < arr.length)
        {
            var intarr : Array<Dynamic> = arr[i].split(",");
            v.push(new Vec2(Std.parseFloat(intarr[0]), Std.parseFloat(intarr[1])));
            i++;
        }
        return v;
    }

    public function new()
    {
    }
}
