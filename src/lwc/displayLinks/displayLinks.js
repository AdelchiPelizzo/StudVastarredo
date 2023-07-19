/**
 * Created by Adelchi on 05/07/2023.
 */

import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class DisplayLinks extends NavigationMixin(LightningElement) {

    handleClick(evt) {
            // Stop the event's default behavior.
            // Stop the event from bubbling up in the DOM.
            evt.preventDefault();
            evt.stopPropagation();
            // Navigate to the Account Home page.
            window.open("https://www.yachtworld.com/yacht/2000-roger-hill-cruising-cutter-8846786/");
        }

}