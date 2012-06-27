bonk
====
Bundle your assets to a single js file

Usage
-----
Below is an example of all the available features. It will bundle the contents of src/, expose lib/some/file.js as the module 'mymodule', add lib/jquery to the output without wrapping it in the commonjs wrapper.

	var fs = require('fs');
	var Bonk = require('./lib/bonk').Bonk;
	var output = new Bonk().bundle(['src/', {name: 'mymodule', file: 'lib/some/file.js'}, {file: 'lib/jquery.js', bare: true}]);
	fs.writeFileSync('app.js', output.js);
	
