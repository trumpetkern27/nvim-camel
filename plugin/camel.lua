vim.api.nvim_create_user_command('Camel', function()
	require('camel').start()
end, {})

vim.api.nvim_create_user_command('CamelHide', function()
	require('camel').destroy()
end, {})
