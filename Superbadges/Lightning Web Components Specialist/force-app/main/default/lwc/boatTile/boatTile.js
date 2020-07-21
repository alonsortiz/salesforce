// imports
import { LightningElement } from 'lwc';

export default class BoatTile extends LightningElement {
    boat;
    selectedBoatId;

    // Getter for dynamically setting the background image for the picture
    get backgroundStyle() { }

    // Getter for dynamically setting the tile class based on whether the
    // current boat is selected
    get tileClass() { 
        const TILE_WRAPPER_SELECTED_CLASS = 'tile-wrapper selected';
        const TILE_WRAPPER_UNSELECTED_CLASS = 'tile-wrapper';
        
        if(selectedBoatId) {
            tileClass = TILE_WRAPPER_SELECTED_CLASS;
        } else {
            tileClass = TILE_WRAPPER_UNSELECTED_CLASS;
        }
    }

    // Fires event with the Id of the boat that has been selected.
    selectBoat() { 
        const boatSelectEvent = new CustomEvent('boatselect', {
            detail: this.boat.Id
        });

        this.dispatchEvent(boatSelectEvent);
    }
}
