/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

import java.util.ArrayList;
import java.util.LinkedList;

/**
 *
 * @author aries
 */
public class UserAccount {
    
    private int UserID = 0;
    private String UserName = "";
    private String AccountType = "";
    
    //tracks all loggedin user's which lets us return the index of the last user
    public static int AllUsers = 0;
    
    //contains pool of all userID's for logged in users
    public static LinkedList<UserAccount> LoggedInUsers = new LinkedList<>();
    
    private static String LoginStatusMessage = "";
    
    //constructor
    public UserAccount(int userId,String UserName,String AccountType){
        this.UserID = userId;
        this.UserName = UserName;
        this.AccountType = AccountType;
    }
    
    //create new user object
    public static int newUser(int id,String name,String type){
        //add new user to the remote LinkedList here 
        //and get the remote data to add to this local LinkedList;
        LoggedInUsers.add(new UserAccount(id, name, type));
        AllUsers++;
        
        return (AllUsers - 1);
    }
    
    //getters
    public int getUserID(){
        return this.UserID;
    }
    
    public String getAccountType(){
        return this.AccountType;
    }
    
    //setters
    public void setUserID(int id){
        this.UserID = id;
    }
    
    public void setAccountType(String type){
        this.AccountType = type;
    }
    
    public String getName(){
        return this.UserName;
    }
    
}
