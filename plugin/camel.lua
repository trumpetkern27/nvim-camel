-- commands
vim.api.nvim_create_user_command('CamelShow', function()
	require('camel').show()
end, {})

vim.api.nvim_create_user_command('CamelWalk', function()
	require('camel').start()
end, {})

vim.api.nvim_create_user_command('CamelHide', function()
	require('camel').destroy()
end, {})

vim.api.nvim_create_user_command('CamelStop', function()
	require('camel').stop()
end, {})
