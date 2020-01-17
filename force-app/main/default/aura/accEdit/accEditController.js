({
    handleSaveRecord: function(component, event, helper) {
        component.find("recordEditor").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS" || saveResult.state === "DRAFT") {
                console.log("Save completed successfully.");
            } else if (saveResult.state === "INCOMPLETE") {
                console.log("User is offline, device doesn't support drafts.");
            } else if (saveResult.state === "ERROR") {
				var errorMessage = JSON.stringify(saveResult.error);
                console.log("Problem saving record, error: " + errorMessage);
				var resultsToast = $A.get("e.force:showToast");
				resultsToast.setParams({
					"title": "Save Error",
					"message": errorMessage
				});
				resultsToast.fire();
				component.set("v.recordSaveError", errorMessage);
            } else {
                console.log('Unknown problem, state: ' + saveResult.state + ', error: ' + JSON.stringify(saveResult.error));
            }
        }));}
})