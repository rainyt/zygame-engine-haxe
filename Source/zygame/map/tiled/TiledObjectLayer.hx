package zygame.map.tiled;

import zygame.map.tiled.TiledObject;
import zygame.map.tiled.TiledBase;

/**
 *  图层对象
 */
class TiledObjectLayer extends TiledBase {

    public var objects:Array<TiledObject>;

    private var _typeMap:Map<String,Array<TiledObject>>;

    private var _nameMap:Map<String,TiledObject>;

    public function new(xml:Xml)
    {
        super(xml);
        objects = new Array<TiledObject>();
        _nameMap = new Map<String,TiledObject>();
        _typeMap = new Map<String,Array<TiledObject>>();

        var objectsIterator:Iterator<Xml> = xml.elementsNamed("object");
        while(objectsIterator.hasNext())
        {
            var object:TiledObject = new TiledObject(objectsIterator.next());
            objects.push(object);
            if(object.name != null)
            {
                _nameMap.set(object.name,object);
            }
            if(object.type != null)
            {
                if(_typeMap.get(object.type) == null)
                    _typeMap.set(object.type,new Array<TiledObject>());
                _typeMap.get(object.type).push(object);   
            }
        }

    }

    /**
     *  根据下标获取对象
     *  @param index - 
     *  @return TiledObject
     */
    public function getObjectByIndex(index:Int):TiledObject
    {
        return objects[index];
    }

    /**
     *  根据名字获取对象
     *  @param name - 
     *  @return TiledObject
     */
    public function getObjectByName(name:String):TiledObject
    {
        return _nameMap.get(name);
    }

    /**
     *  根据类型获取对象列表
     *  @param type - 
     *  @return Array<TiledObject>
     */
    public function getObjectsByType(type:String):Array<TiledObject>
    {
        return _typeMap.get(type);
    }

}