<aura:application controller="ExpenseController">
<!--http://salesforce.stackexchange.com/questions/66954/how-to-navigate-from-one-lightning-component-to-another-lightning-component-->
    <aura:attribute type="Expense__c[]" name="ExpenseList" />
    <aura:attribute type="String" name="FieldListJSON" />
    <aura:handler name="init" value="{!this}" action="c.doInit" />
    <aura:handler event="c:NavigateToDetails" action="{!c.showDetails}"/>
    <aura:handler event="c:NavigateToList" action="{!c.showList}" />
    <div class="slds">
    	{!v.body}
    	<c:AccountLookup ></c:AccountLookup>
    </div>    
</aura:application>