/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

import java.text.DecimalFormat;
import java.util.ArrayList;

/**
 *
 * @author aries
 */
public class ServicesAndPrices {
    //no constructor declaration for this class(Default constructor used
    private ArrayList<Integer> ServiceID = new ArrayList<>();
    private ArrayList<String> ServiceName = new ArrayList<>();
    private ArrayList<String> ServicePrice = new ArrayList<>();
    private ArrayList<String> ServiceDescription = new ArrayList<>();
    private ArrayList<Integer> ServiceDuration = new ArrayList();
    
    //setters
    public void setServicesAndPrices(String name, String price){
        ServiceName.add(name);
        double dprice = Double.parseDouble(price);
        DecimalFormat decformat = new DecimalFormat("#.00");
        price = decformat.format(dprice);
        ServicePrice.add(price);
    }
    
    //setters
    public void setID(int id){
        ServiceID.add(id);
    }
    public void setDescription(String desc){
        ServiceDescription.add(desc);
    }
    public void setDuration(int dur){
        ServiceDuration.add(dur);
    }
    
    //getters
    public int getID(int i){
        return ServiceID.get(i);
    } 
    public String getService(int i){
        return ServiceName.get(i);
    } 
    public String getPrice(int i){
        return ServicePrice.get(i);
    }
    public String getDescription(int i){
        return ServiceDescription.get(i);
    }
    public int getDuration(int i){
        return ServiceDuration.get(i);
    }
    public ArrayList<Integer> getAllIDs(){
        return ServiceID;
    }
    public ArrayList<Integer> getAllDuration(){
        return ServiceDuration;
    }
    public ArrayList<String> getAllDescription(){
        return ServiceDescription;
    }
    public ArrayList<String> getAllService(){
        return ServiceName;
    }
    public ArrayList<String> getAllSericePrices(){
        return ServicePrice;
    }
    public int getNumberOfServices(){
        return ServiceName.size();
    }
    
}
