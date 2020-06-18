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
public class CreateSubscriptionBody {
    
    private String customerId;
    private String paymentMethodId;
    private String priceId;

    public CreateSubscriptionBody(String customerId, String paymentMethodId, String priceId) {
        this.customerId = customerId;
        this.paymentMethodId = paymentMethodId;
        this.priceId = priceId;
    }
    
    public String getCustomerId(){
        return customerId;
    }
    public String getPaymentMethodId(){
        return paymentMethodId;
    }
    public String getPriceId(){
        return priceId;
    }
    
    @Override
    public String toString() {
        return new StringBuilder().append("CustomerInfo{").append("Customer Id: ")
                .append(customerId).append(", Payment Method Id: ")
                .append(paymentMethodId).append(", Price Id: ")
                .append(priceId).append("}").toString();
    }
    
}
