trigger HandleProductPriceChange on Merchandise__c (after update) {
	List<Line_Item_Number__c> openLineItems = 
	[SELECT j.Unit_Price__c, j.Merchandise__r.Price__c
	FROM Line_Item_Number__c j
	WHERE j.Invoice_Statement__r.Status__c = 'Negotiating' 
	AND j.Merchandise__r.id IN :Trigger.new FOR UPDATE];
	
	for (Line_Item_Number__c li: openLineItems) {
		if(li.Merchandise__r.Price__c < li.Unit_Price__c){
			li.Unit_Price__c = li.Merchandise__r.Price__c;
		}
	}
	
	update openLineItems;
}