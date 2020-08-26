import { LightningElement, api, wire, track } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import BOATMC from '@salesforce/messageChannel/BoatMessageChannel__c';
import getBoats from '@salesforce/apex/BoatDataService.getBoats';
import { updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// ...
const SUCCESS_VARIANT = 'success';
const SUCCESS_TITLE = 'Success';
const MESSAGE_SHIP_IT = 'Ship It!';

const ERROR_TITLE = 'Error';
const ERROR_VARIANT = 'error';

export default class BoatSearchResults extends LightningElement {
    selectedBoatId;
    @track columns = [
        { label: 'Name', fieldName: 'Name', editable: true },
        { label: 'Length', fieldName: 'Length__c', type: 'number', editable: true },
        { label: 'Price', fieldName: 'Price__c', type: 'currency', editable: true },
        { label: 'Description', fieldName: 'Description__c', type: 'text', editable: true }
    ];
    @track draftValues = [];
    boatTypeId = '';
    boats;
    @track isLoading = false;

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
        this.notifyLoading(true);

        this.boatTypeId = boatTypeId;

        if(this.boatTypeId !== '') {
            this.notifyLoading(false);
        }
    }

    // this public function must refresh the boats asynchronously
    // uses notifyLoading
    @api
    async refresh() {
        this.notifyLoading(true);

        await refreshApex(this.boats).then(() => {
            this.notifyLoading(false);
        })
    }

    // this function must update selectedBoatId and call sendMessageService
    updateSelectedTile(event) {
        this.selectedBoatId = event.detail.boatId;

        this.sendMessageService(this.selectedBoatId);
    }

    // Publishes the selected boat Id on the BoatMC.
    sendMessageService(boatId) { 
        const payload = { recordId: boatId };

        publish(this.messageContext, BOATMC, payload);
    }

    // This method must save the changes in the Boat Editor
    // Show a toast message with the title
    // clear lightning-datatable draft values
    handleSave(event) {
        const recordInputs = event.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
            return { fields };
        });
        const promises = recordInputs.map(recordInput =>
              //update boat record
              updateRecord(recordInput)
        );
        Promise.all(promises).then(() => { 
            this.dispatchEvent(
                new ShowToastEvent({
                    title: SUCCESS_TITLE,
                    message: MESSAGE_SHIP_IT,
                    variant: SUCCESS_VARIANT
                })
            );
        }).catch(error => { 
            this.dispatchEvent(
                new ShowToastEvent({
                    title: ERROR_TITLE,
                    message: error.body.message,
                    variant: ERROR_VARIANT
                })
            );
        }).finally(() => {
            this.draftValues = [];
            this.refresh(); 
        });
    }

    // Check the current value of isLoading before dispatching the doneloading or loading custom event
    notifyLoading(isLoading) { 
        this.isLoading = isLoading;
        const eventType = isLoading ? 'loading' : 'doneloading';
        
        this.dispatchEvent(new CustomEvent(eventType));
    }
}