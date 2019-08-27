/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

import java.sql.Blob;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author aries
 */
public class ProviderInfo {
     int ID;
    String FirstName;
    String MiddleName;
    String LastName;
    Date DateOfBirth;
    String PhoneNumber;
    String Email; 
    String Company;
    Blob ProfilePic;
    int Ratings;
    String ServiceType;
    String NameAndCompany;
    
    public HoursOpen TimeOpen = new HoursOpen();
    public ServicesAndPrices SVCPRC = new ServicesAndPrices(); //default constructor call
    public P_Address Address;
    
    public ProviderPhotos ThisProvCover = new ProviderPhotos();
    
    public ProviderInfo(){
        //Default Constructor
    }
    
    public ProviderInfo(int ID, String fName, String mName, String lName, Date DOB, String PhNumber, String Company, int Ratings, String ServiceType, String NameAndCompany, Blob ProPic, String Email){
        this.ID = ID;
        this.FirstName = fName;
        this.MiddleName = mName;
        this.LastName = lName;
        this.DateOfBirth = DOB;
        this.PhoneNumber = PhNumber;
        this.Company = Company;
        this.ProfilePic = ProPic;
        this.Ratings = Ratings;
        this.ServiceType = ServiceType;
        this.NameAndCompany = NameAndCompany;
        this.Email = Email;
        
        //tel number class property not set
    }
    //setters
    public void setAddress(int housenumber, String street, String town, String city, String country, int zipcode){
        Address = new P_Address(housenumber, street, town, city, country, zipcode);
    }
    
    //getters
    public int getID(){
        return ID;
    }
    public String getDateOfBirth()
    {
        SimpleDateFormat sdf = new SimpleDateFormat("MMMMMMMMMM dd, yyyy");
        String stringDateValue = sdf.format(DateOfBirth);
        return stringDateValue;
    }
    
    public String getFirstName()
    {
        return FirstName;
    }
    
    public String getMiddleName(){
        return MiddleName;
    }
    
    public String getLastName(){
        return LastName;
    }
    
    public String getPhoneNumber() 
    {
        return PhoneNumber;
    }
    
    public String getEmail(){
        return Email;
    }
   
    public String getCompany(){
        return Company;
    }
    
    public String getServiceType(){
        return ServiceType;
    }
    
    public int getRatings(){
        return Ratings;
    }
  
    public Blob getProfilePicture(){
        return ProfilePic;
    }
 
    public String getNameAndCompany()
    {
        return NameAndCompany;
    }
    
}
