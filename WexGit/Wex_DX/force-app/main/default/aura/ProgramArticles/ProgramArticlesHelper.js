({
	openArticles: function (component, recordId) {
		var action = component.get("c.getArticlesServ");
		action.setParams({
			"recordId": recordId
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {
				var articleList = response.getReturnValue();
				if (articleList) {
					var workspaceAPI = component.find("workspace");
					workspaceAPI.getFocusedTabInfo().then(function (focusedTab) {
						var parentTabId;
						if (focusedTab.isSubtab===true) {
							parentTabId = focusedTab.parentTabId;
						} else {
							parentTabId = focusedTab.tabId;
						}
						articleList.forEach(function (article) {
							workspaceAPI.openSubtab({
								parentTabId: parentTabId,
								recordId: article.Id,
								focus: false
							});
						});
					}).catch(function (error) {
						console.log(error);
					});
				}
			} else if (state === "ERROR") {
				console.error(response.getError());
			}
		});
		$A.enqueueAction(action);
	},
})