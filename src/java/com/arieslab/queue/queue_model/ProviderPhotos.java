/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.arieslab.queue.queue_model;

import java.sql.Blob;

/**
 *
 * @author aries
 */
public class ProviderPhotos {
    
    public static int ProviderID = 0;
    Blob coverPic;
    
    public ProviderPhotos(Blob CoverPhoto){
        coverPic = CoverPhoto;
    }
    
    public ProviderPhotos(){
    }
    
    public void setCover(Blob cover){
        coverPic = cover;
    }
    
    public Blob getCover(){
        
        return coverPic;
    }
    
}
