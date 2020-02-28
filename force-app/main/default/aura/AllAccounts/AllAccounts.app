<aura:application >
  <div class="slds" style="margin-top:10px;margin-left:10px;">
    <ltng:require styles="/resource/SLDS103/assets/styles/salesforce-lightning-design-system-ltng.css" />
    <span class="slds-icon__container slds-icon-standard-account">
        <c:svg class="slds-icon" xlinkHref="/resource/SLDS103/assets/icons/standard-sprite/svg/symbols.svg#account" />
        <span class="slds-assistive-text">Account Icon</span>
    </span>
     <c:Button_BK class="slds-button slds-button--neutral" 
             label="Details" 
             svgXlinkHref="/resource/SLDS103/assets/icons/standard-sprite/svg/symbols.svg#account" 
             svgClass="slds-icon slds-icon-text-default"
             onclick="{!c.showDetails}"
 	  />
      <c:AccountList />

      

  </div>
</aura:application>