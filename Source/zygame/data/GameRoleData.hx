package zygame.data;

/**
 *  游戏角色数据
 */
class GameRoleData {
    
    /**
     *  默认的属性
     */
    public var defalultAttr:Map<String,Dynamic>;

    private var _xmlData:Xml;

    public function new()
    {
        
    }

    /**
     *  进行初始化角色游戏数据
     *  @param xml - 
     */
    public function init(xml:Xml):Void
    {
        _xmlData = xml;
        if(_xmlData == null)
        {
            trace("Waring:无游戏数据");
            return;
        }
        defalultAttr = new Map<String,Dynamic>();
        var attrs:Iterator<Xml> = _xmlData.elementsNamed("init").next().elements();
        while(attrs.hasNext())
        {
            var attrXml:Xml = attrs.next();
            defalultAttr.set(attrXml.get("id"),attrXml.get("value"));
            trace("初始化数据：",attrXml.get("id"),attrXml.get("value"));
        }
    }

    /**
     *  判断角色数据是否存在，如果存在则可以为战斗角色
     *  @param id - 角色标示
     */
    public function hasData(id:String):Bool
    {
        if(_xmlData == null)
            return false;
        if(_xmlData.elementsNamed(id).hasNext())
            return true;
        return false;
    }

}