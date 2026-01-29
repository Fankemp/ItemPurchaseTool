trigger PurchaseLineTrigger on PurchaseLine__c (after insert, after update, after delete, after undelete) {

    // Создаем список для передачи в хендлер
    List<PurchaseLine__c> linesToProcess;

    // Выбираем правильный контекст:
    // Если это удаление, берем старые данные (Trigger.old)
    if (Trigger.isDelete) {
        linesToProcess = Trigger.old;
    } else {
        // Во всех остальных случаях (insert, update, undelete) берем новые данные
        linesToProcess = Trigger.new;
    }

    // Вызываем наш хендлер и передаем ему список
    PurchaseLineTriggerHandler.calculateTotals(linesToProcess);
}