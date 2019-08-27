/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

import java.util.ArrayList;

/**
 *
 * @author aries
 */
public class ExistingProviderAccountsModel {
   
    //this stores the actual user accounts
    private ArrayList ExistingAccounts = new ArrayList();
    public static ArrayList<ExistingProviderAccountsModel> SignupUserList = new ArrayList();
    private static int allUserIndex = -1;
    
    //this is used to access the methods
    //public static ExistingProviderAccountsModel AccountsList = new ExistingProviderAccountsModel();
    
    public ExistingProviderAccountsModel(){}
    
    public static int getUserIndex(){
        SignupUserList.add(new ExistingProviderAccountsModel());
        allUserIndex++;
        return allUserIndex;
    }
    
    public void addAccountToList(int ID){
        
        ExistingAccounts.add(ID);
        
    }
    
    public int getAccountFromList(int index){
        
        return (int)ExistingAccounts.get(index);
        
    }
    
    public int getAccountListSize(){
        return ExistingAccounts.size();
    }
    
    public void clearAccountsList(){
        ExistingAccounts.clear();
    }
    
    public ArrayList getList(){
        return ExistingAccounts;
    }
    
}
