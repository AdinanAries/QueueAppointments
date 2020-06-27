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
public class RetryInvoiceBody {
    
    private String paymentMethodId;
    private String customerId;
    private String invoiceId;
    
    public String getPaymentMethodId(){
        return paymentMethodId;
    }
    public String getCustomerId(){
        return customerId;
    }
    public String getInvoiceId(){
        return invoiceId;
    }
    
    @Override
    public String toString() {
        return new StringBuilder().append("CustomerInfo{").append("Customer Id: ")
                .append(customerId).append(", Payment Method Id: ")
                .append(paymentMethodId).append(", Ivoice Id: ")
                .append(invoiceId).append("}").toString();
    }
}
