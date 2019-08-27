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
public class BookedAppointmentList {
    
    private int AppointmentID;
    private int ProviderID;
    private String ProviderName;
    private String ProviderCompany;
    private Date dateOfAppointment;
    private String timeOfAppointment;
    private String ProviderTel;
    private String ProviderEmail;
    private String AppointmentReason;
    private Blob DisplayPic;
    
    public BookedAppointmentList(int id, int pID, String pName, String pCompany, String pTel, String pEmail, Date date, String time, Blob Pic){
        
        AppointmentID = id;
        ProviderID = pID;
        ProviderName = pName;
        ProviderCompany = pCompany;
        ProviderTel = pTel;
        ProviderEmail = pEmail;
        dateOfAppointment = date;
        timeOfAppointment = time;
        DisplayPic = Pic;
        
    }
    
    public void setAppointmentReason(String reason){
        AppointmentReason = reason;
    }
    
    public String getReason(){
        return AppointmentReason;
    }
   
    public int getProviderID(){
        return ProviderID;
    }
    
    public String getProviderName(){
        return ProviderName;
    }
    
    public String getProviderCompany(){
        return ProviderCompany;
    }
    
    public String getProviderTel(){
        return ProviderTel;
    }
    
    public String getProviderEmail(){
        return ProviderEmail;
    }
    
    public Date getDateOfAppointment(){
        return dateOfAppointment;
    }
    
    public String getTimeOfAppointment(){
        return timeOfAppointment;
    }
    
    public int getAppointmentID(){
        return AppointmentID;
    }
    
    public void addDisplayPic(Blob pic){
        DisplayPic = pic;
    }
    
    public Blob getDisplayPic(){
        return DisplayPic;
    }
}
