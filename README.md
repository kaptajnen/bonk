bonk
====

Usage
-----
Bundle contents of src/ and lib/ folder and save as app.js

	var fs = require('fs');
	var Bonk = require('./lib/bonk').Bonk;
	var js = new Bonk().bundle(['src/', 'lib/']);
	fs.writeFileSync('app.js', js);
	
