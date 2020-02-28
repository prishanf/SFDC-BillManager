global class MapWrapper{

global class Test{
    
}


    private Map<Object, Object> theMap;

    public MapWrapper()
    {
        theMap = new Map<Object, Object>();
    }

    // Expose Map methods from your wrapper here, I'll do get() and values() as an example
    public Object get(Object key)
    {
        return theMap.get(key);
    }
       
    public Object put(Object key, Object value)
    {
        return theMap.put(key,value);
    }   

    public List<Object> values()
    {
        return theMap.values();
    }

}