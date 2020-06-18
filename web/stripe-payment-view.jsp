<%-- 
    Document   : stripe-payment-view
    Created on : May 27, 2020, 2:52:17 AM
    Author     : aries
--%>

<%@page import="javax.swing.JOptionPane"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<!--
To change this license header, choose License Headers in Project Properties.
To change this template file, choose Tools | Templates
and open the template in the editor.
-->
<html>
    <head>
        <title>Queue Payment</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script src="https://js.stripe.com/v3/"></script>
        <link rel="stylesheet" href="StripeElements.css">
        <link href="https://fonts.googleapis.com/css?family=Roboto" rel='stylesheet'>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
        
        <link rel="manifest" href="/manifest.json" />
        <link rel="shortcut icon" type="image/png" href="favicon.png"/>
        
        <link rel="apple-touch-icon" href="./HomeIcons/Icon3.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon1.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon2.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon4.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon5.png" />
        <link rel="apple-touch-icon" href="./HomeIcons/Icon6.png" />
        <meta name="apple-mobile-web-app-status-bar" content="#ffffff" />
    </head>
    <body>
        <%
            String Email = "";
            
            try{
                Email = request.getParameter("providerEmail");
            }catch(Exception e){}
            
            //JOptionPane.showMessageDialog(null, Email);
        %>
        <script>
            var isStripeCustomerCreated = true;
        </script>
        <div class="container">
            <div>
                
                <div id="width: 100vw; padding: 5px; text-align: center;">
                    <p style="text-align: center; padding: 5px;">
                        <img src="QueueLogo.png" style="opacity: 0.2; height: 50px; width: 120px;"/>
                    </p>
                    <h1 style="color: darkblue; font-weight: bolder;">Pick a subscription plan</h1>
                </div>
                <!-- Use the CSS tab above to style your Element's container. -->
                <div class="subscriptions-list">
                    <div class="subscription-row">
                        <div class="each-subscription active" id="MonthlySubscription" onclick="pickSubcription('MonthlySubscription')">
                            <p style="font-weight: bolder;">Monthly</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$24.99 <span style="font-size: 13px; color: #ff6b6b">- default</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every month</small></p>
                        </div>
                        <div class="each-subscription" id="3MonthsSubscription" onclick="pickSubcription('3MonthsSubscription')">
                            <p style="font-weight: bolder;">3 Months</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$69.99 <span style="font-size: 13px; color: #ff6b6b">- save $5</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every three months</small></p>
                        </div>
                    </div>
                    <div class="subscription-row">
                        <div class="each-subscription" id="6MonthsSubscription" onclick="pickSubcription('6MonthsSubscription')">
                            <p style="font-weight: bolder;">6 Months</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$139.99 <span style="font-size: 13px; color: #ff6b6b">- save $10</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every six months</small></p>
                        </div>
                        <div class="each-subscription" id="YearlySubscription" onclick="pickSubcription('YearlySubscription')">
                            <p style="font-weight: bolder;">Yearly</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$269.99 <span style="font-size: 13px; color: #ff6b6b">- save $30</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every year</small></p>
                        </div>
                    </div>
                    <input id="SubscriptionPriceID" type="hidden" value="1" />
                </div>
                <form id="subscription-form">
                    
                    <p style="text-align: left; padding: 0 10px; color: #636363;">
                        <span style="font-size: 13px;">Your subscription will start now.</span>
                        <br/>
                        <small style="font-size: 13px;">
                            <i class="fa fa-arrow-right"></i> Total due now 
                            $<span id="subscriptionTotal">24.99</span>
                        </small>
                        <br/>
                        <small style="font-size: 13px;">
                            <i class="fa fa-arrow-right"></i> Subscribing to a 
                            <span style="font-weight: bolder;" id="subscriptionDesc">monthly</span>
                             plan
                        </small>
                    </p>
                    <p style="color: darkblue; font-weight: bolder;">Enter your card details.</p>
                        <div id="card-element" class="MyCardElement">
                          <!-- Elements will create input elements here -->
                        </div>

                    <!-- We'll put the error messages in this element -->
                    <div id="card-errors" role="alert"></div>
                    <button type="submit">Subscribe</button>
                </form>
                
                <script>
                    function pickSubcription(type){
                        let subscriptionNodes = document.getElementsByClassName("each-subscription");
                        let NodesArray = Array.from(subscriptionNodes);
                        NodesArray.forEach(node => {
                            node.classList.remove('active');
                        });
                        document.getElementById(type).classList.add('active');
                        if(type === "3MonthsSubscription"){
                            document.getElementById("SubscriptionPriceID").value = "3";
                            document.getElementById("subscriptionTotal").innerText = "69.99";
                            document.getElementById("subscriptionDesc").innerText = "3 months";
                        }else if(type === "6MonthsSubscription"){
                            document.getElementById("SubscriptionPriceID").value = "6";
                            document.getElementById("subscriptionTotal").innerText = "139.99";
                            document.getElementById("subscriptionDesc").innerText = "6 months";
                        }else if(type === "YearlySubscription"){
                            document.getElementById("SubscriptionPriceID").value = "12";
                            document.getElementById("subscriptionTotal").innerText = "269.99";
                            document.getElementById("subscriptionDesc").innerText = "yearly";
                        }else {
                            document.getElementById("SubscriptionPriceID").value = "1";
                            document.getElementById("subscriptionTotal").innerText = "24.99";
                            document.getElementById("subscriptionDesc").innerText = "monthly";
                        }
                    }
                </script>
                
                <script>

                    function CreateCustomer(){
                        //let billingEmail = document.querySelector("#email").value;
                        $.ajax({
                            type: "POST",
                            url: "./createCustomer",
                            data: "email=" + "m.adinan@yahoo.com",
                            success: function(result){
                                console.log(result);
                            }
                        });
                    }
                    
                    //CreateCustomer();

                    // Set your publishable key: remember to change this to your live publishable key in production
                    // See your keys here: https://dashboard.stripe.com/account/apikeys
                    var stripe = Stripe('pk_test_0etJCeBvPiJRDEEzxSLVXgBW009YQmsWbU');
                    var elements = stripe.elements();

                    // Set up Stripe.js and Elements to use in checkout form
                    var style = {
                      base: {
                        color: "#32325d",
                        fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
                        fontSmoothing: "antialiased",
                        fontSize: "16px",
                        "::placeholder": {
                          color: "#aab7c4"
                        }
                      },
                      invalid: {
                        color: "#fa755a",
                        iconColor: "#fa755a"
                      }
                    };

                    var cardElement = elements.create("card", { style: style });
                    cardElement.mount("#card-element");

                    cardElement.on('change', showCardError);

                    function showCardError(event) {
                      let displayError = document.getElementById('card-errors');
                      if (event.error) {
                        displayError.textContent = event.error.message;
                      } else {
                        displayError.textContent = '';
                      }
                    }

                    function createPaymentMethod(cardElement, customerId, priceId) {
                        return stripe
                          .createPaymentMethod({
                            type: 'card',
                            card: cardElement,
                          })
                          .then((result) => {
                            if (result.error) {
                              displayError(error);
                            } else {
                              createSubscription({
                                customerId: customerId,
                                paymentMethodId: result.paymentMethod.id,
                                priceId: priceId,
                              });
                            }
                          });
                      }
                      
                      /*fetch('./createSubscription', {
                            method: 'post',
                            headers: {
                              'Content-type': 'application/json',
                            },
                            body: JSON.stringify({
                              customerId: "customerId",
                              paymentMethodId: "paymentMethodId",
                              priceId: "priceId",
                            }),
                          });*/
                      
                      function createSubscription({ customerId, paymentMethodId, priceId }) {
                        return (
                          fetch('/createSubscription', {
                            method: 'post',
                            headers: {
                              'Content-type': 'application/json',
                            },
                            body: JSON.stringify({
                              customerId: customerId,
                              paymentMethodId: paymentMethodId,
                              priceId: priceId,
                            }),
                          })
                            .then((response) => {
                              return response.json();
                            })
                            // If the card is declined, display an error to the user.
                            .then((result) => {
                              if (result.error) {
                                // The card had an error when trying to attach it to a customer.
                                throw result;
                              }
                              return result;
                            })
                            // Normalize the result to contain the object returned by Stripe.
                            // Add the addional details we need.
                            .then((result) => {
                              return {
                                paymentMethodId: paymentMethodId,
                                priceId: priceId,
                                subscription: result,
                              };
                            })
                            // Some payment methods require a customer to be on session
                            // to complete the payment process. Check the status of the
                            // payment intent to handle these actions.
                            .then(handlePaymentThatRequiresCustomerAction)
                            // If attaching this card to a Customer object succeeds,
                            // but attempts to charge the customer fail, you
                            // get a requires_payment_method error.
                            .then(handleRequiresPaymentMethod)
                            // No more actions required. Provision your service for the user.
                            .then(onSubscriptionComplete)
                            .catch((error) => {
                              // An error has happened. Display the failure to the user here.
                              // We utilize the HTML element we created.
                              showCardError(error);
                            })
                        );
                      }
                </script>





                <!--form action="/StripeTestApp/acceptpaymentrequest" method="POST">
                    <script
                        src="https://checkout.stripe.com/checkout.js" class="stripe-button"
                        data-key="pk_test_0etJCeBvPiJRDEEzxSLVXgBW009YQmsWbU"
                        data-amount="999"
                        data-name="TestBiz"
                        data-description="Example charge"
                        data-image="https://stripe.com/img/documentation/checkout/marketplace.png"
                        data-locale="auto"
                        data-currency="usd">
                    </script>


                </form-->
                <!--form action="/purchase" method="POST">
                    <script
                        src="https://checkout.stripe.com/checkout.js"
                        class="stripe-button"
                        data-key="pk_test_0etJCeBvPiJRDEEzxSLVXgBW009YQmsWbU"
                        data-name="Queue Subscription"
                        data-description="Fillout the payment form below"
                        data-amount="999"
                        data-image="HomeIcons/Icon3.png"
                        data-locale="auto"
                        data-currency="usd">
                    </script>
                </form-->
            </div>
        </div>
    </body>
</html>
