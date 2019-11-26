trigger ClosedOpportunityTrigger on Opportunity (after insert, after update) {
    
    List<Task> taskList = new List<Task>();
    
    for (Opportunity opp : [SELECT Id,StageName FROM Opportunity WHERE Id IN :Trigger.New]) {
        if (opp.StageName == 'Closed Won') {
            Task newTask = new Task(Subject = 'Follow Up Test Task', WhatId = opp.Id);
            taskList.add(newTask);
        }
    }
    
    if (taskList.size() > 0) {
        insert taskList;
    }
    
}