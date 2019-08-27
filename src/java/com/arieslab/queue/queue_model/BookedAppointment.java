/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

import java.util.Date;

/**
 *
 * @author aries
 */
public class BookedAppointment{
    
    private String ServiceProviderName;
    private String ServiceProviderCompany;                                                               
    private Date AppointmentDate;
    private String AppointmentTime;
    private String OrderedServices;
    private Double ServicesCost;
    
    public BookedAppointment(String ProviderName, String ServiceProviderCompany, Date AppointmentDate, String AppointmentTime, String OrderedServices, Double ServicesCost){
        this.ServiceProviderName = ProviderName;
        this.ServiceProviderCompany = ServiceProviderCompany;
        this.AppointmentDate = AppointmentDate;
        this.AppointmentTime = AppointmentTime;
        this.OrderedServices = OrderedServices;
        this.ServicesCost = ServicesCost;
    }
    //getters
    public String getProviderName(){
        return ServiceProviderName;
    }
    public String getProviderCompany(){
        return ServiceProviderCompany;
    }
    public Date getAppointmentDate(){
        return AppointmentDate;
    }
    public String getAppointmentTime(){
        return AppointmentTime;
    }
    public String getOrderedServices(){
        return OrderedServices;
    }
    public Double getServicesCost(){
        return ServicesCost;
    }
}