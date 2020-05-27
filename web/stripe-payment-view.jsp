<%-- 
    Document   : stripe-payment-view
    Created on : May 27, 2020, 2:52:17 AM
    Author     : aries
--%>

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
    </head>
    <body>
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
        <form action="/purchase" method="POST">
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
        </form>
    </body>
</html>
