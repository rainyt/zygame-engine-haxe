package zygame.data;

/**
 *  特效数据，独立可重复使用，不做修改处理
 */
class EffectData {

    private var _data:Dynamic;

    public function new(data:String):Void
    {
        _data = haxe.Json.parse(data);
    }   

    /**
     *  渲染名字
     *  @return String
     */
    public function name():String
    {
        return _data.name;
    }

    /**
     *  便于查找的名字
     *  @return String
     */
    public function nickName():String
    {
        return _data.findName;
    }

    /**
     *  物理伤害
     *  @return Float
     */
    public function AD():Float
    {
        return _data.wfight;
    }

    /**
     *  魔法伤害
     *  @return Float
     */
    public function AP():Float
    {
        return _data.mfight;
    }

    /**
     *  击飞值
     *  @return Int
     */
    public function hitY():Int
    {
        return _data.hitY;
    }

    /**
     *  击退值
     *  @return Int
     */
    public function hitX():Int
    {
        return _data.hitX;
    }

    /**
     *  渲染模式
     *  @return String
     */
    public function blendMode():String
    {
        return _data.blendMode;
    }

    /**
     *  X轴
     *  @return Float
     */
    public function x():Float
    {
        return _data.x;
    }

    /**
     *  Y轴
     *  @return Float
     */
    public function y():Float
    {
        return _data.y;
    }

    /**
     *  角度
     *  @return Float
     */
    public function rotation():Float
    {
        return _data.rotation;
    }

    /**
     *  FPS，如果为-1则以角色的FPS进行渲染
     *  @return Int
     */
    public function fps():Int
    {
        if(_data.fps)
            return _data.fps;
        else
            return -1;
    }

    /**
     *  僵硬值
     *  @return Int
     */
    public function straight():Int
    {
        if(_data.stiff == null)
            return 0;
        return _data.stiff;
    }
}