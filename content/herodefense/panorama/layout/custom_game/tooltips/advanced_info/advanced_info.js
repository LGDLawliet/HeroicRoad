var self = $.GetContextPanel();
// var expTable = [1, 2, 3, 4, 5, 6, 8];


let classSave = [];

function ReSetClass() {
	for (let index = 0; index < classSave.length; index++) {
		const element = classSave[index];
		element.target.SetHasClass(element.class,false);
		
	}
	classSave = [];
}


function setupTooltip() {
	ReSetClass();
	let data = JSON.parse( $.GetContextPanel().GetAttributeString("data", ""));
	if (data.type==AdvancedInfo_Type_Base) {
		SetUpInfoBase(data);
		return;
	}


}


function SetUpInfoBase(data) {

	data = restoreDataFromJSON(data);


	if (data.info.title) {
		self.FindChildTraverse("advanced_Title").text = data.info.title;
	}else{
		self.FindChildTraverse("advanced_Title").text = "";
	}
	if (data.info.subTitle) {
		self.FindChildTraverse("advanced_subTitle").text = data.info.subTitle;
	}else{
		self.FindChildTraverse("advanced_subTitle").text = "";
	}

	if (data.info.text) {
		self.FindChildTraverse("Description").text = data.info.text;
	}else{
		self.FindChildTraverse("Description").text = "";
	}


	

	if (data.classChange) {
		if (data.classChange.Contents) {
			self.SetHasClass(data.classChange.Contents,true);
			classSave[classSave.length] = {
				target : self,
				class :data.classChange.Contents,
			}
		}
	}
}






(function () {
	// let upgradeList = $("#UpgradeList");
	// upgradeList.RemoveAndDeleteChildren();
	// for (let i = 0; i < expTable.length; i++) {
	// 	let upgrade = $.CreatePanel("Panel", upgradeList, "Upgrade" + i, {});
	// 	upgrade.BLoadLayoutSnippet("Upgrade");
	// }
})();
