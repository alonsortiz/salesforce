<aura:application extends="force:slds">
    <lightning:card class="backgroundTitle slds-m-around_small">
        <aura:set attribute="title">
            <div class="slds-text-heading_medium slds-text-color_default slds-m-around_xx-small">
                <lightning:icon iconName="custom:custom54" size="medium" class="slds-m-right_x-small" />
                Friends with Boats
            </div>        
        </aura:set>
    </lightning:card>
    <lightning:layout class="slds-m-around_small">
        <lightning:layoutItem class="slds-col slds-size_8-of-12">
            <c:BoatSearch />
        </lightning:layoutItem>
        <lightning:layoutItem class="slds-col slds-size_4-of-12">
            <lightning:card class="slds-m-left_small">
                <c:BoatDetails />
            </lightning:card>
            <lightning:card class="slds-m-left_small">
                <c:Map />
            </lightning:card>
        </lightning:layoutItem>
    </lightning:layout>
</aura:application>