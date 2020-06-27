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
        <!--link href="QueueCSS.css" rel="stylesheet" media="screen" type="text/css"/-->
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
    <body onload="document.getElementById('PageLoader').style.display = 'none';">
        
        <div id="PageLoader" class="QueueLoader" style="display: block;">
            <div class="QueueLoaderSpinner"></div>
            <img src="icons/Logo.png" alt=""/>
        </div>
        
        <%
            
            String Email = "";
            String ProviderId = "";
            
            try{
                Email = request.getParameter("providerEmail");
                ProviderId = request.getParameter("ProviderId");
                %>
                    <script>
                        var StripeEmail = '<%=Email%>';
                        var ProviderId = '<%=ProviderId%>';
                    </script>
                <%
            }catch(Exception e){}
            
            //JOptionPane.showMessageDialog(null, Email);

            /*Cookie myName = new Cookie("Name","Mohammed");
            myName.setMaxAge(60*60*24); 
            response.addCookie(myName);*/

            //Changing some domain cookie properties
            Cookie cookie = null;
             Cookie[] cookies = null;

             // Get an array of Cookies associated with the this domain
             cookies = request.getCookies();

             String CookieText = "";

             if( cookies != null ) {

                for (int i = 0; i < cookies.length; i++) {

                   cookie = cookies[i];
                   CookieText += cookie.getName()+"="+cookie.getValue();

                   /*if((cookie.getName()).compareTo("JSESSIONID") == 0 ) {
                      //cookie.setHttpOnly(false);
                      //cookie.setSecure(false);
                      //cookie.setMaxAge(60*60*999999999);
                      //response.addCookie(cookie);

                   }*/
                }
             } else {
                 //JOptionPane.showMessageDialog(null, "no cookies found");
             }
             //JOptionPane.showMessageDialog(null, CookieText);
             response.setHeader("Set-Cookie", "Name=Mohammed;"+CookieText+"; HttpOnly; SameSite=None; Secure");
             //JOptionPane.showMessageDialog(null, response.getHeader("Set-Cookie"));
        %>
        <script>
            document.cookie = "SameSite=None";
            document.cookie = "SameSite=None; Secure";
            
            var isStripeCustomerCreated = false;
            var CustomerId = '';
            
            /*if(StripeEmail !== null){
                localStorage.setItem('emailForStripe', StripeEmail);
            }
            if(StripeEmail === null){
                StripeEmail = localStorage.getItem('emailForStripe');
            }*/
        </script>
        <div class="container">
            <div>
                
                <div id="width: 100vw; padding: 5px; text-align: center;">
                    <p style="text-align: center; padding: 5px;">
                        <img src="QueueLogo.png" style="height: 50px; width: 120px;"/>
                    </p>
                    <h1 style="color: darkblue; font-weight: bolder;">Pick a subscription plan</h1>
                </div>
                <!-- Use the CSS tab above to style your Element's container. -->
                <div class="subscriptions-list">
                    <div class="subscription-row">
                        <div class="each-subscription active" id="MonthlySubscription" onclick="pickSubcription('MonthlySubscription')">
                            <p style="font-weight: bolder;">Monthly</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$22.99 <span style="font-size: 13px; color: #ff6b6b">- default</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every month</small></p>
                        </div>
                        <div class="each-subscription" id="3MonthsSubscription" onclick="pickSubcription('3MonthsSubscription')">
                            <p style="font-weight: bolder;">3 Months</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$63.99 <span style="font-size: 13px; color: #ff6b6b">- save $5</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every three months</small></p>
                        </div>
                    </div>
                    <div class="subscription-row">
                        <div class="each-subscription" id="6MonthsSubscription" onclick="pickSubcription('6MonthsSubscription')">
                            <p style="font-weight: bolder;">6 Months</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$127.99 <span style="font-size: 13px; color: #ff6b6b">- save $10</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every six months</small></p>
                        </div>
                        <div class="each-subscription" id="YearlySubscription" onclick="pickSubcription('YearlySubscription')">
                            <p style="font-weight: bolder;">Yearly</p>
                            <p style="font-weight: bolder; font-size: 20px; color: #6699ff">$245.99 <span style="font-size: 13px; color: #ff6b6b">- save $30</span></p>
                            <p style="margin-top: -20px;"><small style="font-size: 11px; color: #ababab;">pay every year</small></p>
                        </div>
                    </div>
                    <input id="SubscriptionPriceID" type="hidden" value="price_1Gv6vGFNNtFYAcj1GBjxRXhf" />
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
                    <button id='SubscribeBtn' type="submit">Subscribe</button>
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
                            document.getElementById("SubscriptionPriceID").value = "price_1Gv73WFNNtFYAcj1ERN1vhoy";
                            document.getElementById("subscriptionTotal").innerText = "69.99";
                            document.getElementById("subscriptionDesc").innerText = "3 months";
                        }else if(type === "6MonthsSubscription"){
                            document.getElementById("SubscriptionPriceID").value = "price_1Gv701FNNtFYAcj1vjk8uwuC";
                            document.getElementById("subscriptionTotal").innerText = "139.99";
                            document.getElementById("subscriptionDesc").innerText = "6 months";
                        }else if(type === "YearlySubscription"){
                            document.getElementById("SubscriptionPriceID").value = "price_1Gv75PFNNtFYAcj1hRka53sz";
                            document.getElementById("subscriptionTotal").innerText = "269.99";
                            document.getElementById("subscriptionDesc").innerText = "yearly";
                        }else {
                            document.getElementById("SubscriptionPriceID").value = "price_1Gv6vGFNNtFYAcj1GBjxRXhf";
                            document.getElementById("subscriptionTotal").innerText = "24.99";
                            document.getElementById("subscriptionDesc").innerText = "monthly";
                        }
                    }
                </script>
                
                <script>

                    /*fetch('./retryPaymentWithNewInvoice', {
                            method: 'post',
                            headers: {
                              'Content-type': 'application/json'
                            },
                            body: JSON.stringify({
                              customerId: "customerId",
                              paymentMethodId: "paymentMethodId",
                              invoiceId: "invoiceId"
                            })
                          });*/
    
                    localStorage.setItem('latestInvoicePaymentIntentStatus', '');
    

                    function CreateCustomer(){
                        //let billingEmail = document.querySelector("#email").value;
                        let provEmail = StripeEmail;
                        $.ajax({
                            type: "POST",
                            url: "./createCustomer",
                            data: "email=" + provEmail,
                            success: function(result){
                                //console.log(result.customer.id);
                                CustomerId = result.customer.id;
                                $.ajax({
                                    type: "POST",
                                    url: "./SaveStripeCustId",
                                    data: "StripeCustId=" + result.customer.id + "&ProviderId=" + ProviderId,
                                    success: function(result){
                                        //alert("CustomerAdded to database");
                                    }
                                });
                            }
                        });
                    }
                    
                    //checking to see if customer has been created if not then create customer
                    $.ajax({
                        type: "POST",
                        url: "./isStripeCustomerCreated",
                        data: "ProviderId=" + ProviderId,
                        success: function(result){
                            
                            if(result === "notFound"){
                                CreateCustomer();
                                //alert(result);
                            }else{
                                CustomerId = result;
                                //alert(result);
                            }
                        }
                    });

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

                    document.getElementById('SubscribeBtn').addEventListener('click', function(event){
                        event.preventDefault();
                        document.getElementById("PageLoader").style.display = "block";
                        let priceId = document.getElementById('SubscriptionPriceID').value;
                        //alert(priceId);
                        //alert(CustomerId);
                        //alert(cardElement);
                        createPaymentMethod(cardElement, CustomerId, priceId);
                    });

                    function createPaymentMethod(cardElement, customerId, priceId) {
                        return stripe
                          .createPaymentMethod({
                            type: 'card',
                            card: cardElement,
                          })
                          .then((result) => {
                            if (result.error) {
                              //displayError(error);
                              //alert(result.error);
                              document.getElementById("PageLoader").style.display = "none";
                            } else {
                                
                                if(localStorage.getItem('latestInvoicePaymentIntentStatus') === 'requires_payment_method'){
                                    let invoiceId = localStorage.getItem('latestInvoiceId');
                                    retryInvoiceWithNewPaymentMethod(customerId, result.paymentMethod.id, invoiceId, priceId);
                      
                                }else{
                                    createSubscription({
                                      customerId: customerId,
                                      paymentMethodId: result.paymentMethod.id,
                                      priceId: priceId,
                                    });
                                }
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
                          fetch('./createSubscription', {
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
                                  document.getElementById("PageLoader").style.display = "none";
                                // The card had an error when trying to attach it to a customer.
                                //alert(result.error);
                                throw result;
                              }
                              //console.log(result);
                              
                              $.ajax({
                                    type: "POST",
                                    url: "./SaveStripeSubscriptionInfo",
                                    data: "ProductId="+result.plan.product+"&SubscriptionID="+result.id+"&PriceID="+result.plan.id+"&ProviderID="+ProviderId,
                                    success: function(result){
                                        
                                    }
                                });
                                //onSubscriptionComplete(result);
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
                            .then(result => {
                                //console.log(result);
                                return handleCustomerActionRequired(result.subscription, false, result.priceId,  result.paymentMethodId, false);
                            })
                            // If attaching this card to a Customer object succeeds,
                            // but attempts to charge the customer fail, you
                            // get a requires_payment_method error.
                            .then(result => {
                                //console.log(result);
                                return handlePaymentMethodRequired(result.subscription, result.paymentMethodId, result.priceId );
                            })
                            // No more actions required. Provision your service for the user.
                            .then((result)=>{
                                onSubscriptionComplete(result);
                            })
                            .catch((error) => {
                              // An error has happened. Display the failure to the user here.
                              // We utilize the HTML element we created.
                              document.getElementById("PageLoader").style.display = "none";
                              showCardError(error);
                            })
                        );
                      }
                      
                      function onSubscriptionComplete(result) {
                        // Payment was successful.
                        console.log(result);
                        if (result.subscription.status === 'active') {
                            
                            $.ajax({
                                type: "POST",
                                url: "./UpdateSubscriptionStatus",
                                data: "status=active&ProviderID=" + ProviderId,
                                success: function(result){
                                    alert("Subscription succeeded. Go back to your app and click on 'go to home screen'");
                                    document.getElementById("PageLoader").style.display = "none";
                                    window.close();
                                }
                            });
                            
                          // Change your UI to show a success message to your customer.
                          // Call your backend to grant access to your service based on
                          // `result.subscription.items.data[0].price.product` the customer subscribed to.
                          
                        }/*else{
                            throw new Error(localStorage.getItem('latestInvoicePaymentIntentStatus'));
                        }*/
                      }
                      
                      function handleCustomerActionRequired(
                        subscription,
                        invoice,
                        priceId,
                        paymentMethodId,
                        isRetry
                      ) {
                        
                        if (subscription && subscription.status === 'active') {
                          // Subscription is active, no customer actions required.
                          return { subscription, priceId, paymentMethodId };
                        }

                        // If it's a first payment attempt, the payment intent is on the subscription latest invoice.
                        // If it's a retry, the payment intent will be on the invoice itself.
                        let paymentIntent = invoice ? invoice.payment_intent : subscription.latest_invoice.payment_intent;

                        if (
                          paymentIntent.status === 'requires_action' ||
                          (isRetry === true && paymentIntent.status === 'requires_payment_method')
                        ) {
                          return stripe
                            .confirmCardPayment(paymentIntent.client_secret, {
                              payment_method: paymentMethodId,
                            })
                            .then((result) => {
                              if (result.error) {
                                  alert(result.error.message);
                                // Start code flow to handle updating the payment details.
                                // Display error message in your UI.
                                // The card was declined (i.e. insufficient funds, card has expired, etc).
                                throw result;
                              } else {
                                if (result.paymentIntent.status === 'succeeded') {
                                    onSubscriptionComplete({
                                        subscription: {
                                            status: 'active'
                                        }
                                    });
                                  // Show a success message to your customer.
                                  // There's a risk of the customer closing the window before the callback.
                                  // We recommend setting up webhook endpoints later in this guide.
                                  return {
                                    priceId: priceId,
                                    subscription: subscription,
                                    invoice: invoice,
                                    paymentMethodId: paymentMethodId,
                                  };
                                }
                              }
                            })
                            .catch((error) => {
                                document.getElementById("PageLoader").style.display = "none";
                              //displayError(error);
                            });
                        } else {
                          // No customer action needed.
                          return { subscription, priceId, paymentMethodId };
                        }
                      }
                      
                      function handlePaymentMethodRequired(
                        subscription,
                        paymentMethodId,
                        priceId) {
                            if (subscription.status === 'active') {
                              // subscription is active, no customer actions required.
                              return { subscription, priceId, paymentMethodId };
                            } else if (
                              subscription.latest_invoice.payment_intent.status ===
                              'requires_payment_method'
                            ) {
                              // Using localStorage to manage the state of the retry here,
                              // feel free to replace with what you prefer.
                              // Store the latest invoice ID and status.
                              //console.log(subscription.latest_invoice.payment_intent.status);
                              localStorage.setItem('latestInvoiceId', subscription.latest_invoice.id);
                              localStorage.setItem('latestInvoicePaymentIntentStatus', subscription.latest_invoice.payment_intent.status);
                              throw { error: { message: 'Your card was declined.' } };
                              
                            } else {
                              return { subscription, priceId, paymentMethodId };
                            }
                      }
                      
                      function retryInvoiceWithNewPaymentMethod(
                        customerId,
                        paymentMethodId,
                        invoiceId,
                        priceId
                      ) {
                        return (
                          fetch('./retryPaymentWithNewInvoice', {
                            method: 'post',
                            headers: {
                              'Content-type': 'application/json',
                            },
                            body: JSON.stringify({
                              customerId: customerId,
                              paymentMethodId: paymentMethodId,
                              invoiceId: invoiceId,
                            }),
                          })
                            .then((response) => {
                              return response.json();
                            })
                            // If the card is declined, display an error to the user.
                            .then((result) => {
                                //console.log(result);
                              if (result.error) {
                                // The card had an error when trying to attach it to a customer.
                                //document.getElementById("PageLoader").style.display = "none";
                                throw result;
                              }
                              return result;
                            })
                            // Normalize the result to contain the object returned by Stripe.
                            // Add the addional details we need.
                            .then((result) => {
                                //console.log(result);
                              return {
                                // Use the Stripe 'object' property on the
                                // returned result to understand what object is returned.
                                invoice: result,
                                paymentMethodId: paymentMethodId,
                                priceId: priceId,
                                isRetry: true,
                              };
                            })
                            // Some payment methods require a customer to be on session
                            // to complete the payment process. Check the status of the
                            // payment intent to handle these actions.
                            .then(result => {
                                console.log(result);
                                return handleCustomerActionRequired(false, result.invoice, result.priceId,  result.paymentMethodId, result.isRetry);
                            })
                            // No more actions required. Provision your service for the user.
                            .then( result => {
                                    if(result !== undefined);
                                        onSubscriptionComplete(result);
                                }
                            )
                            .catch((error) => {
                                console.log(error);
                                document.getElementById("PageLoader").style.display = "none";
                              // An error has happened. Display the failure to the user here.
                              // We utilize the HTML element we created.
                              //displayError(error);
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
