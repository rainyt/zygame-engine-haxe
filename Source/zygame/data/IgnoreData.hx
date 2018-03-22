package zygame.data;

/**
 *  用于计算忽略
 */
class IgnoreData {

    public static var ROLE:IgnoreData = new IgnoreData(0,[0]);

    public var ignoreData:Array<Int>;

    public var id:Int;

    public function new(id:Int,ignore:Array<Int>)
    {
        this.id = id;
        ignoreData = ignore;
    }

    /**
     *  检查是否忽略
     *  计算方法：每个忽略数据都会有一个id，判断忽略中是否包含它，如果包含就属于忽略
     *  @param data - 忽略数据  
     *  @return Bool
     */
    public function cheakIgnore(data:IgnoreData):Bool
    {
        if(data.ignoreData.indexOf(id) != -1 || ignoreData.indexOf(data.id) != -1)
        {
            return true;
        }
        return false;
    }

}