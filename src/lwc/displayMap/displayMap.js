/**
 * Created by Adelchi on 11/07/2023.
 */

import { LightningElement, api, wire } from 'lwc';
import getListAccountAddresses from '@salesforce/apex/DataProvider.getListAccountAddresses';
import { getLocationService } from 'lightning/mobileCapabilities';

export default class DisplayMap extends LightningElement {
    @api greetingMessage;

    @api filterByOwner;

    myLocation;
    myLocationService;

    directionsListWired = [];
    mapMarkers = [];
    zoomLevel = 15;
    center;

   connectedCallback() {
       this.myLocationService = getLocationService();
       console.log('geolocation service  '+JSON.stringify(this.myLocationService));
       console.log('is available  '+this.myLocationService.isAvailable());
       getListAccountAddresses({filter: this.filterByOwner}).then( data => {
              if(data){
                  this.directionsListWired = data;
                  this.fillMapMarkersStructure();

              }else if (error) {
                  this.isLoading =false;
                  this.records = undefined;
                  this.error = error;
              }
          })
       }

//    @wire(getListAccountAddresses, {filter: false})
//    wiredRelatedAccounts(result){
//        const{data,error} = result;
//        if(data){
//            this.directionsListWired = data;
//            this.fillMapMarkersStructure();
//
//        }else if (error) {
//            this.isLoading =false;
//            this.records = undefined;
//            this.error = error;
//        }
//    }

    fillMapMarkersStructure() {
        console.log('filling up markers structure')
        this.mapMarkers = this.directionsListWired.map(direction => {

            if(direction.type == 'A'){
               return {
                  location: {
                      City: direction.city,
                      Country: direction.country,
                      PostalCode: direction.postalCode,
                      Street: direction.street

                  },
                  mapIcon: {
                                       path: 'M -123 -247 l 250 0 l -125 250 z m 60 35 l 65 125 l 65 -125 z ',
                                       fillColor: '#099c30',
                                       fillOpacity: .85,
                                       strokeWeight: 1,
                                       scale: .10,
                                   },
                  icon: 'standard:account',
                  title: direction.name,
               };
           }else if (direction.type == 'L') {
               return {
                  location: {
                      City: direction.city,
                      Country: direction.country,
                      PostalCode: direction.postalCode,
                      Street: direction.street

                  },

                  mapIcon: {
                                       path: 'M -123 -247 l 250 0 l -125 250 z m 60 35 l 65 125 l 65 -125 z',
                                       fillColor: '#f85a21',
                                       fillOpacity: .85,
                                       strokeWeight: 1,
                                       scale: .10,
                                   },
                  icon: 'standard:lead',
                  title: direction.name
               };
           }
        });
    }

    showMyLocationMobile(event) {
        if(this.myLocationService != null && this.myLocationService.isAvailable()) {
            this.myLocationService.getCurrentPosition({enableHighAccuracy: false}).then( (results) => {
                this.myLocation = result.coords;
                this.center = {
                                     location: {
                                         Latitude: result.coords.latitude,
                                         Longitude: result.coords.longitude,
                                    },
                                 }
            }).catch(error => console.log(error))
         }else{
             alert('geoLocation not available')
         }
     }

     showMyLocation(){

         let latitude = "";
         let longitude = "";
         if (navigator.geolocation) {
             window.navigator.geolocation.getCurrentPosition(position => {
                 latitude = position.coords.latitude;
                 longitude = position.coords.longitude;
                 console.log(latitude);
                 console.log(longitude);
                 this.center = {
                     location: {
                         Latitude: latitude,
                         Longitude: longitude,
                    },
                 }
             });
         }
    }

}