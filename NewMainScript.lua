-- dogvape bootstrap. Legacy API names and cache layout are kept for compatibility.
repeat task.wait() until game:IsLoaded()
local environment = getgenv()
local state = environment.shared or shared or {}
environment.shared = state
assert(not state.VapeExecuted, 'dogvape is already loaded')
local repository = 'IlIllIllIIIIIIII/dogvapev2'
local revision = 'main'
local root = 'vape/'
local watermark = '--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n'
for _, name in ipairs({'readfile', 'writefile', 'isfolder', 'makefolder', 'listfiles', 'loadstring'}) do
	assert(type(environment[name]) == 'function', 'dogvape requires '..name)
end
local fileExists = isfile or function(path)
	local ok, contents = pcall(readfile, path)
	return ok and type(contents) == 'string' and #contents > 0
end
for _, folder in ipairs({'vape', 'vape/Libraries', 'vape/CustomModules', 'vape/Profiles', 'vape/assets'}) do
	if not isfolder(folder) then
		makefolder(folder)
	end
end
-- Remove only generated source caches when switching forks; preserve custom code and profiles.
if not state.VapeDeveloper and (not fileExists(root..'dogvape-source.txt') or readfile(root..'dogvape-source.txt') ~= repository) then
	for _, folder in ipairs({'vape', 'vape/Libraries', 'vape/CustomModules'}) do
		for _, path in ipairs(listfiles(folder)) do
			if path:sub(-4) == '.lua' and fileExists(path) then
				local contents = readfile(path)
				if contents:sub(1, #watermark) == watermark then
					if delfile then
						delfile(path)
					else
						error('dogvape needs delfile to refresh the existing source cache')
					end
				end
			end
		end
	end
end
writefile(root..'commithash.txt', revision)
local function fetch(path)
	local location = root..path
	if state.VapeDeveloper and fileExists(location) then
		return readfile(location)
	end
	local source = game:HttpGet('https://raw.githubusercontent.com/'..repository..'/'..revision..'/'..path, true)
	assert(type(source) == 'string' and #source > 0 and source ~= '404: Not Found', 'dogvape could not download '..path)
	if path:sub(-4) == '.lua' then
		source = watermark..source
	end
	writefile(location, source)
	return source
end
environment.vapeGithubRequest = fetch
state.vapeGithubRequest = fetch
-- Refresh the visible shell even when an older fork used the same cache directory.
fetch('GuiLibrary.lua')
fetch('Universal.lua')
if not state.VapeDeveloper then
	local ok, result = pcall(fetch, 'CustomModules/'..game.PlaceId..'.lua')
	if not ok then
		warn('dogvape: game-specific module unavailable: '..tostring(result))
	end
end
local mainSource = fetch('MainScript.lua')
local main, compileError = loadstring(mainSource, '@dogvape/MainScript.lua')
assert(main, compileError)
writefile(root..'dogvape-source.txt', repository)
return main()
