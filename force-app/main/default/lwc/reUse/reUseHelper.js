const columnsortData = (fieldname, direction,fetchedcurrentRecords)  => {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(fetchedcurrentRecords));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        }); 

        // set the sorted data to data table dataD:\LWC Project\TrailHead\TrailHead\force-app\main\default\lwc\reUse\reUseHelper.js
       return parseData;
    }

    const formatcurrentData = (dataForm)  => {
        
        let  dataRecords = JSON.parse(JSON.stringify(dataForm));
        for(var index in dataRecords)
        {
            dataRecords[index].recordLink = '/'+dataRecords[index].Id;
            var currentRec = dataRecords[index];
            for(var field in currentRec)
            {
                if(typeof currentRec[field] == 'object')
                {
                    for(var parentField in currentRec[field])
                    {
                        if(parentField != 'Id')
                        {                                
                            currentRec[field+'.'+parentField] = currentRec[field][parentField];                                
                        }
                        if(parentField == 'Name')
                        {
                            currentRec[field+'Link'] = '/'+currentRec[field]['Id'];
                        }                        
                    }
                }
            }
        }  
        return dataRecords;
    }
  

    export { formatcurrentData, columnsortData};