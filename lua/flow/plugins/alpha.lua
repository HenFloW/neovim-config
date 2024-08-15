return {

	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		_Gopts = {
			position = "center",
			hl = "Type",
			wrap = "overflow",
		}

		-- DASHBOARD HEADER
		--- @return string
		local function getGreeting(name)
			local tableTime = os.date("*t")
			local datetime = os.date(" %Y-%m-%d-%A   %H:%M:%S ")
			local hour = tableTime.hour
			local greetingsTable = {
				[1] = "  Sleep well",
				[2] = "  Good morning",
				[3] = "  Good afternoon",
				[4] = "  Good evening",
				[5] = "󰖔  Good night",
			}
			local greetingIndex = 0
			if hour == 23 or hour < 7 then
				greetingIndex = 1
			elseif hour < 12 then
				greetingIndex = 2
			elseif hour >= 12 and hour < 18 then
				greetingIndex = 3
			elseif hour >= 18 and hour < 21 then
				greetingIndex = 4
			elseif hour >= 21 then
				greetingIndex = 5
			end
			return datetime .. "  " .. greetingsTable[greetingIndex] .. ", " .. name
		end

		-- Function to count symbols in a line (including spaces and ignoring multibyte characters)
		local function countSymbols(line)
			return #line:gsub("[\128-\191]", "")
		end

		-- Function to create the header
		local function createHeader(header, config)
			local maxLen = 0
			local returnTable = {}

			-- Find the longest line in the header
			for _, block in ipairs(header) do
				for _, line in ipairs(block) do
					local lineLength = countSymbols(line)
					if lineLength > maxLen then
						maxLen = lineLength
					end
				end
			end

			-- Process each line in the header according to the flex configuration
			for _, block in ipairs(header) do
				for _, line in ipairs(block) do
					local padding = 0
					if config["flex"] == "right" then
						padding = maxLen - countSymbols(line)
					elseif config["flex"] == "center" then
						padding = math.floor((maxLen - countSymbols(line)) / 2)
					end
					table.insert(returnTable, string.rep(" ", padding) .. line)
				end

				-- Add gap between blocks if specified
				if config["gap"] and config["gap"] > 0 then
					for _ = 1, config["gap"] do
						table.insert(returnTable, string.rep(" ", maxLen))
					end
				end
			end

			-- Add top margin if specified
			if config["margin"] and config["margin"]["top"] > 0 then
				for _ = 1, config["margin"]["top"] do
					table.insert(returnTable, 1, string.rep(" ", maxLen))
				end
			end

			-- Add bottom margin if specified
			if config["margin"] and config["margin"]["bottom"] > 0 then
				for _ = 1, config["margin"]["bottom"] do
					table.insert(returnTable, string.rep(" ", maxLen))
				end
			end

			return returnTable
		end

		local logo = {
			[[███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
			[[████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
			[[██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
			[[██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
			[[██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
			[[╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
		}

		local greeting = getGreeting("Henrik")

		local headerElements = {
			logo,
			{ greeting },
		}

		local config = {
			["margin"] = {
				["top"] = 1,
				["bottom"] = 2,
			},
			["gap"] = 1,
			["flex"] = "center",
		}

		dashboard.section.header.val = createHeader(headerElements, config)

		dashboard.section.buttons.val = {
			dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button(
				"f",
				"  Find file",
				":cd $HOME | silent Telescope find_files hidden=true no_ignore=true <CR>"
			),
			dashboard.button("r", "󰄉  Recent files", ":Telescope oldfiles <CR>"),
			dashboard.button("p", "  Projects", ":e $HOME/Documents/Repo.nosync <CR>"),
			dashboard.button("u", "󱐥  Update plugins", "<cmd>Lazy update<CR>"),
			dashboard.button("c", "  Settings", ":e $HOME/.config/nvim/<CR>"),
			dashboard.button("q", "󰿅  Quit", "<cmd>qa<CR>"),
		}

		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			desc = "Add Alpha dashboard footer",
			once = true,
			callback = function()
				local stats = require("lazy").stats()
				local ms = math.floor(stats.startuptime * 100 + 0.5) / 100
				dashboard.section.footer.val =
					{ " ", " ", " ", " Loaded " .. stats.count .. " plugins  in " .. ms .. " ms " }
				dashboard.section.header.opts.hl = "DashboardFooter"
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		dashboard.opts.opts.noautocmd = true
		alpha.setup(dashboard.opts)
	end,
}
