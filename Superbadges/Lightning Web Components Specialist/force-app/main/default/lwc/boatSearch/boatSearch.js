import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class BoatSearch extends NavigationMixin(LightningElement) {
    isLoading = false;

    // Handles loading event
    handleLoading() { 
        this.isLoaded = true;
    }

    // Handles done loading event
    handleDoneLoading() { 
        this.isLoaded = false;
    }

    // Handles search boat event
    // This custom event comes from the form
    searchBoats(event) {
        this.template.querySelector('c-boat-search-results').searchBoats(event.detail);
    }

    createNewBoat() { 
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Boat__c',
                actionName: 'new'
            }
        });
    }
}