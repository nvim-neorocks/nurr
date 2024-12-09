#!/usr/bin/env -S nvim -u NONE -U NONE -N -i NONE -l

-- Copied over from rocks-git.nvim

---@param rev string?
---@return boolean
local function is_version(rev)
	if not rev then
		return false
	end
	if tonumber(rev) then
		return true
	end
	local version_str = rev:gsub("v", "")
	return vim.iter(vim.gsplit(version_str, ".", { plain = true })):all(function(str)
		return tonumber(str) ~= nil
	end)
end

---@param rev string?
---@return vim.Version?
local function get_version(rev)
	if not is_version(rev) then
		return
	end
	local ok, version = pcall(vim.version.parse, rev)
	return ok and version or nil
end

---@param stdout string
---@return string | nil
local function parse_git_latest_semver_tag(stdout)
	local latest_tag = nil
	local latest_version = nil
	for tag in stdout:gmatch("refs/tags/([^\n]+)") do
		local version = get_version(tag)
		if version and latest_version then
			if version > latest_version then
				latest_tag = tag
				latest_version = version
			end
		elseif version then
			latest_tag = tag
			latest_version = version
		end
	end
	return latest_tag
end

---@param args string[] git CLI arguments
---@param on_exit fun(sc: vim.SystemCompleted)|nil Called asynchronously when the git command exits.
---@param opts? vim.SystemOpts
---@return vim.SystemObj | nil
---@see vim.system
local function git_cli(args, on_exit, opts)
	opts = opts or {}
	local git_cmd = vim.list_extend({
		"git",
	}, args)
	---@type boolean, vim.SystemObj | string
	local ok, so_or_err = pcall(vim.system, git_cmd, opts, on_exit)
	if ok then
		---@cast so_or_err vim.SystemObj
		return so_or_err
	else
		---@cast so_or_err string
		---@type vim.SystemCompleted
		local sc = {
			code = 1,
			signal = 0,
			stderr = ("Failed to invoke git: %s"):format(so_or_err),
		}
		if on_exit then
			on_exit(sc)
		end
	end
end

local function echo_latest_git_tag()
	local sc = git_cli({ "for-each-ref", "--format", "%(refname)", "refs/tags" }):wait()
	if sc.code == 0 and sc.stdout then
		local latest_tag, _ = parse_git_latest_semver_tag(sc.stdout or "")
		if latest_tag then
			io.write(latest_tag)
		end
	end
end

echo_latest_git_tag()
