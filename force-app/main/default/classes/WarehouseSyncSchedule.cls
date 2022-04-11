global class WarehouseSyncSchedule implements Schedulable {
    global void execute(SchedulableContext SC) {
        WarehouseCalloutService.runWarehouseEquipmentSync();
   }
}