global class WarehouseCalloutServiceMock   implements HttpCalloutMock{
    // implement http mock callout
    global static String pId;
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('[{"id":"'+pId+'","replacement":false,"quantity":10,"name":"UPS 2000 VA","maintenanceperiod":180,"lifespan":60,"cost":1350,"sku":"1111"},{"replacement":true,"quantity":194,"name":"Fuse 8A","maintenanceperiod":0,"lifespan":0,"cost":5,"sku":"100002"}]');
        response.setStatusCode(200);
        return response; 
    }
}