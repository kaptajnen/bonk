fs = require 'fs'
path = require 'path'

class Bonk
	bundle: (paths) ->
		modules = ''
		#modules +=  @makeModule filename.slice(pathname.length, -path.extname(filename).length), @processFile filename for filename in @getFiles pathname for pathname in paths
		
		for pathname in paths
			if typeof pathname == 'string'
				stats = fs.statSync(pathname)
				if stats.isDirectory()
					files = @getFiles pathname
					for filename in files
						source = @processFile filename
						modules += @makeModule filename.slice(pathname.length, -path.extname(filename).length), source
				else if stats.isFile()
					source = @processFile filename
					modules += @makeModule filename.slice(pathname.length, -path.extname(filename).length), source
			else if typeof pathname == 'object'
				source = @processFile pathname.file
				modules += @makeModule pathname.name, source
		output = js: """
			(function(){
				var modules = {#{modules}};
			
				this.require = function require(name)
				{
					if (modules[name])
					{
						var module = {id: name, exports: {}};
						var path = modules[name].path;
						modules[name].module(module, module.exports, function(name)
						{
							if (name.indexOf('./') === 0 || name.indexOf('../') === 0)
							{
								while (true)
								{
									if (name.indexOf('./') === 0)
									{
										name = name.slice(2);
									}
									else if (name.indexOf('../') === 0)
									{
										name = name.slice(3);
										if (path.indexOf('/') === -1)
											path = '';
										else
											path = path.slice(0, path.lastIndexOf('/')+1);
									}
									else
									{
										break;
									}
								}
							
								return require(path + name);
							}
							else
							{
								return require(name);
							}
						});
					
						return module.exports;
					}
					else
					{
						throw 'Module ' + name + ' does not exist';
					}
				}
			})()
		"""
		
		
	getFiles: (pathname) ->
		files = []
		if path.existsSync pathname
			current = fs.readdirSync pathname
			for currentPath in current
				stats = fs.statSync path.join(pathname, currentPath)
				if stats.isDirectory()
					files = files.concat @getFiles(path.join(pathname, currentPath))
				else
					files.push path.join(pathname, currentPath);
		return files
		
	processFile: (filename) ->
		extension = (path.extname filename).slice(1)
		if processors[extension]
			return processors[extension] filename
			
	makeModule: (modulename, source) ->
		if ! source
			return
			
		pathname = path.join(modulename, '..')
			
		if pathname == '.'
			pathname = ''
			
		return "'#{modulename}': {path: '#{pathname}', module: function (module, exports, require) {#{source}}},"
		
processors =
	js: (filename) ->
		fs.readFileSync filename, 'utf8'
	coffee: (filename) ->
		(require 'coffee-script').compile fs.readFileSync(filename, 'utf8'), bare:true
	jade: (filename) ->
		'var jade = require(\'jade\'); module.exports = ' + (require 'jade').compile fs.readFileSync(filename, 'utf8'), client: true

exports.Bonk = Bonk
exports.processors = processors