document.addEventListener("DOMContentLoaded", bookingData);

function bookingData() {
	document.getElementById("submitInfo").addEventListener("click", function(event) {
		var req = new XMLHttpRequest();
		var submitSite = "http://httpbin.org/post";
		var payLoad = 
		{
			"firstname":null,
            "lastname":null,
            "middlename":null,
            "streetnumber":null,
            "city":null,
            "state":null,
            "country":null,
            "postalcode":null,
            "phonenumber":null,
            "email":null,
            "passportnumber":null,
            "passportcountry":null,
            "expirydate":null,
		};
		payLoad.firstname = document.getElementById("firstname").value;
        payLoad.lastname = document.getElementById("lastname").value;
        payLoad.middlename = document.getElementById("middlename").value;
        payLoad.streetnumber = document.getElementById("streetnumber").value;
        payLoad.city = document.getElementById("city").value;
        payLoad.state = document.getElementById("state").value;
        payLoad.country = document.getElementById("country").value;
        payLoad.postalcode = document.getElementById("postalcode").value;
        payLoad.phonenumber = document.getElementById("phonenumber").value;
		payLoad.email = document.getElementById("email").value;
        payLoad.passportnumber = document.getElementById("passportnumber").value;
        payLoad.passportcountry = document.getElementById("passportcountry").value;
        payLoad.expirydate = document.getElementById("expirydate").value;

		let requiredFields = ['firstname', 'lastname', 'streetnumber', 'city', 'state', 'country', 'postalcode', 'email', 'phonenumber', 'passportnumber', 'passportcountry', 'expirydate'];

		let doesNotHaveValue = !!requiredFields.find(field => !payLoad[field]);

		if (doesNotHaveValue) {
			const test = document.getElementById('test');
			test.innerHTML = "Please Fill all required values";
			return;
		}

		req.open("POST", submitSite, true);
		req.setRequestHeader("Content-Type", "text/plain");
		req.addEventListener("load", function(resp) {
			console.log("Yoooo");
			console.log(resp);
			console.log(req);
			if(req.status >=200 && req.status <400) {
				var response = JSON.parse(req.responseText);
                console.log("Response Submitted");
				console.log(response);
				const test = document.getElementById('test');
                test.innerHTML = "Registration Successful! Your id is: 12. Please use this id when you log in next time";
			}
			else {
				console.log("Error in network request: "+req.statusText);
			}});
		req.send(JSON.stringify(payLoad));
		event.preventDefault();
		
	});
}