bonk
====
Bundle your assets to a single js file

Usage
-----
Bundle contents of src/ and lib/ folder and save as app.js

	var fs = require('fs');
	var Bonk = require('./lib/bonk').Bonk;
	var output = new Bonk().bundle(['src/', 'lib/']);
	fs.writeFileSync('app.js', output.js);
	
