/*
	Cood language
*/

function cood(c, callback, debug) {
	debug = debug || false;
	
	var cells = [];
	for(i = 0; i <= 65535; i++) {
		cells[i] = 0;
	}
	
	var pointer = 32767;
	
	c = c.split("\n");
	var j = c.length-1;
	for(i = 0; i <= j; i++) {
		c[i] = c[i].trim();
	}
	
	var n = 0;
	var l;
	
	for(i = 0; i <= j; i++) {
		n++;
		l = c[i];
		if(wildcard("Know a joke*", l)) continue;
		if(wildcard("The bill*please", l)) return;
		if(wildcard("I want this*", l)) cells[pointer] += 1;
		if(wildcard("I don*t want this*", l)) cells[pointer] -= 1;
		if(wildcard("What do you have for dessert*", l)) pointer += 1;
		if(wildcard("What do you have for tidbit*", l)) pointer -= 1;
		if(wildcard("May I ask something*", l)) cells[pointer] = prompt("");
		if(wildcard("I*m hungry*", l)) callback(String.fromCharCode(cells[pointer]) + "\n");
		if(wildcard("I*m very hungry*", l)) callback(String.fromCharCode(cells[pointer]));
		if(wildcard("I hate this*", l)) cells[pointer] = 0;
		
		// get number
		if(wildcard("I want * of this", l)) {
			var num =   l.replace("I want ", "");
				num = num.replace(" of this.", "");
				num = num.replace(" of this", "");
			cells[pointer] = parseInt(num);
		}
		
		// add number
		if(wildcard("More * of this", l)) {
			var num =   l.replace("More ", "");
				num = num.replace(" of this.", "");
				num = num.replace(" of this", "");
			cells[pointer] += parseInt(num);
		}
		
		// subtract number
		if(wildcard("Less * of this", l)) {
			var num =   l.replace("Less ", "");
				num = num.replace(" of this.", "");
				num = num.replace(" of this", "");
			cells[pointer] -= parseInt(num);
		}
		
		// loop 
		if(l=="What do you suggest?") {
			loop_line = i;
		}
		
		if(l=="Nothing more?") {
			if(cells[pointer]>0 && typeof loop_line != 'undefined') {
				i = loop_line;
			}
		}
		
		if(debug) callback("\n" + "Pointer: " + pointer + " / Value: " + cells[pointer] + " / Line " + i + ": " + l + "\n");
	}
}

function preg_quote(str) {
  return String(str).replace(new RegExp('[.\\\\+*?\\[\\^\\]$(){}=!<>|:\\' + ('\\' || '') + '-]', 'g'), '\\$&');
}

function wildcard(pattern, string) {
	pattern = preg_quote(pattern);
	pattern = pattern.split("\\*").join(".*");
	pattern = pattern.split("\\?").join(".");
	return new RegExp(pattern).test(string);
}
