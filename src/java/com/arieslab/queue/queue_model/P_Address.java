/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

/**
 *
 * @author aries
 */
public class P_Address {
        int HouseNumber;
        String StreetName;
        String Town;
        String City;
        String Country;
        int Zipcode;
        
        P_Address(int housenumber, String street, String town, String city, String country, int zipcode)
        {
            HouseNumber = housenumber;
            StreetName = street;
            Town = town;
            City = city;
            Country = country;
            Zipcode = zipcode;
        }
        
        public int getHouseNumber()
        {
            return HouseNumber;
        }
        
        public String getStreet()
        {
            return StreetName;
        }
        
        public String getTown()
        {
            return Town;
        }
        
         public String getCity()
         {
             return City;
         }
         
         public String getCountry()
         {
             return Country;
         }
         
         public int getZipcode()
         {
             return Zipcode;
         }
}
