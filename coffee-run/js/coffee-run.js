$(document).ready(function(){
	$('#coffee-form').submit(function(e){
		e.preventDefault();
		validateForm();
	});

	$('.warning').hover(function(){
			$(this).parent().find('.validation-text').removeClass('hide');
		}, function() {
			$(this).parent().find('.validation-text').addClass('hide');
		}

	);
});

function validateForm() {
    var ordererName = $('#orderer-name input').val();
    var ordererBeverage = $('#orderer-beverage input').val();
    var isValid = true;

    if(ordererBeverage == null || ordererBeverage == "") {
    	$('#orderer-beverage .warning').removeClass('hide');
    	$('#orderer-beverage .validation-text p').text("If you don't tell me what you want, I can't get you what you want.");
    	isValid = false;
    } else if (isGibberish(ordererBeverage)){
    	$('#orderer-beverage .warning').removeClass('hide');
    	$('#orderer-beverage .validation-text p').text("For the love of God, please don’t enter jibberish. You’re not a monkey!");
    	isValid = false;
    }

    if(ordererName == null || ordererName == "") {
        $('#orderer-name .warning').removeClass('hide');
        isValid = false;
    }

    if (isValid) {
    	// Remove warning
    	$('.warning').addClass('hide');
    }
    
    return isValid;
}

function isGibberish(s) {

	/*
		Checking if the input is gibberish to prevent spam
		Credit by Arty Effem (http://www.webdeveloper.com/forum/showthread.php?157846.html)

		This simple algorithm checks the ratio between vows/consonances in an input.
	*/

	var v=1, c=1, ratio, len, gibberish=false;

	if(typeof s != 'undefined' && s.length) {
		len=s.length;

		for(var i=0; i<len; i++) {
			if(/[aeiou]/i.test(s.charAt(i))) {
				v++;
			} else if(/[bcdfghjklmnpqrstvwxyz]/i.test(s.charAt(i))) {
		 		c++; 
		 	}
		}

		ratio=v/(c+v);

		if(ratio < 0.3 || ratio >0.6) {
			gibberish=true;
		}
	}

	return gibberish;
}