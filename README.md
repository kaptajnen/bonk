bonk
====
Bundle your assets to a single js file

Usage
-----
Bundle contents of src/ and bundle lib/some/file.js as 'mymodule'. Save the result to app.js.

	var fs = require('fs');
	var Bonk = require('./lib/bonk').Bonk;
	var output = new Bonk().bundle(['src/', {name: 'mymodule', file: 'lib/some/file.js'}]);
	fs.writeFileSync('app.js', output.js);
	
