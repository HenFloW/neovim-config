return {
	"windwp/nvim-ts-autotag",
	config = function()
		local autotag = require("nvim-ts-autotag")
		autotag.setup({
			opts = {
				enable_close = true,
				enable_rename = true,
				enable_close_on_slash = true,
			},
			per_filetype = {
				["html"] = {
					enable_close = false,
				},
			},
		})
	end,
}
