global class ObjectList extends VisualEditor.DynamicPickList{
    //Default method which can be ignored , kept that for your better understanding of stucture of VisualEditor Namespace
    global override VisualEditor.DataRow getDefaultValue(){
        VisualEditor.DataRow defaultValue = new VisualEditor.DataRow('red', 'RED');
        return defaultValue;
    }
    
    //Prepare the list of Object and return
    global override VisualEditor.DynamicPickListRows getValues() {
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        
        VisualEditor.DynamicPickListRows  objValues = new VisualEditor.DynamicPickListRows();
        List<String> entities = new List<String>(schemaMap.keySet());
        entities.sort();
        for(String name : entities)
        {
            objValues.addRow( new VisualEditor.DataRow(name, name));
        }     
        return objValues;
    }
}