var ctx = $("#line-chart");
var numer_of_places = 2161;

var lineChart = new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [
            "Medical Centers","Barbershops","Medical Estheticians","Hair Salons","Holistic Medicines","Day Spa","Beauty Salons",
            "Physical Therapists","Dentists","Massage Places","Tatoo Shops","Piercing Places","Podiatry Places","Nail Salons",
            "Personal Trainers"
        ],
        datasets: [{
            label: "(Total: "+numer_of_places+ ") Number of places",
            backgroundColor: "rgb(55,160,245)",
            //borderColor: "rgb(255,233,107)",
            borderWidth: 1,
            pointBackgroundColor: "#4ed164",
            pointRadius: 7,
            pointBorderColor: "#fff",
            data: [213,133,453,344,543,665,137,224,212,453,344,143,165,337,602]
        }]
    }/*,
    options: {
        scales: {
          yAxes: [{
            ticks: {
              callback: function(value, index, values) {
                return value.toLocaleString("en-US",{style:"currency", currency:"USD"});
              }
            }
          }]
        }
      }*/
});
