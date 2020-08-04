import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';

// ...
export default class BoatSearchResults extends LightningElement {
    selectedBoatId;
    columns = [];
    boatTypeId = '';
    boats;
    isLoading = false;

    // wired message context
    @wire(MessageContext)
    messageContext;
    // wired getBoats method 
    @wire(getBoats, {boatTypeId: '$boatTypeId'})
    wiredBoats(result) { 
        if(result) {
            this.boats = result;
        }
    }

    // public function that updates the existing boatTypeId property
    // uses notifyLoading
    @api 
    searchBoats(boatTypeId) { 
        this.boatTypeId = boatTypeId;
    }

    // this public function must refresh the boats asynchronously
    // uses notifyLoading
    refresh() { }

    // this function must update selectedBoatId and call sendMessageService
    updateSelectedTile(event) {
        this.selectedBoatId = event.detail.boatId;
        //sendMessageService(this.selectedBoatId);
    }

    // Publishes the selected boat Id on the BoatMC.
    sendMessageService(boatId) { }

    // This method must save the changes in the Boat Editor
    // Show a toast message with the title
    // clear lightning-datatable draft values
    handleSave() {
        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        /*const promises = recordInputs.map(recordInput =>
              //update boat record
          );*/
        Promise.all(promises)
            .then(() => { })
            .catch(error => { })
            .finally(() => { });
    }
    // Check the current value of isLoading before dispatching the doneloading or loading custom event
    notifyLoading(isLoading) { }
}
