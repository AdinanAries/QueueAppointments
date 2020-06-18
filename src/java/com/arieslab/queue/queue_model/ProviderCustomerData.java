/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

import java.sql.Blob;
import java.util.Date;

/**
 *
 * @author aries
 */
//Customer account data model

public class ProviderCustomerData{
    
    private int CustomerID;
    private String FirstName;
    private String MiddleName;
    private String LastName;
    private Blob ProfilePic;
    private String MobileNumber;
    private Date DateOfBirth;
    private String Email;
    
    public P_Address CustomerAddress;
    
    //variable of class this same class type
    //public static ProviderCustomerData eachCustomer;
    
    public ProviderCustomerData(int id, String fname, String mname, String lname, Blob pic, String mobile, Date dob, String email){
        CustomerID = id;
        FirstName = fname;
        MiddleName = mname;
        LastName = lname;
        ProfilePic = pic;
        MobileNumber = mobile;
        DateOfBirth = dob;
        Email = email;
    }
    
    public String getAddress(int hNumber, String street, String town, String city, String country, int zCode){
        CustomerAddress = new P_Address(hNumber, street, town, city, country, zCode);
        
        String H_Number = Integer.toString(CustomerAddress.getHouseNumber());
        String Street = CustomerAddress.getStreet().trim();
        String Town = CustomerAddress.getTown().trim();
        String City = CustomerAddress.getCity().trim();
        String Country = CustomerAddress.getCountry().trim();
        String ZipCode = Integer.toString(CustomerAddress.getZipcode());
        
        String Address = H_Number + " " + Street + ", " + Town + ", " + City + ", " + Country + " " + ZipCode;
        
        return Address;
    }
    
    public int getUserID(){
        return CustomerID;
    }
    public String getFirstName(){
        return FirstName;
    }
    public String getMiddleName(){
        return MiddleName;
    }
    public String getLastName(){
        return LastName;
    }
    public Blob getProfilePic(){
        return ProfilePic;
    }
    public String getEmail(){
        return Email;
    }
    public String getPhoneNumber(){
        return MobileNumber;
    }
    
    
}
