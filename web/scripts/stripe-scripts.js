
//this function is for creating a stripe customer
/*function createCustomer() {
  let billingEmail = document.querySelector('#email').value;
  return fetch('/createCustomer', {
    method: 'post',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email: billingEmail
    })
  })
    .then(response => {
      return response.json();
    })
    .then(result => {
      // result.customer.id is used to map back to the customer object
      // result.setupIntent.client_secret is used to create the payment method
      return result;
    });
}*/


