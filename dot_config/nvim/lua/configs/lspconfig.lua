-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- Use new nvim 0.11+ API
local servers = {
	"html",
	"cssls",
	"ts_ls",
	"eslint",
	"tailwindcss",
	"dockerls",
	"marksman",
	"terraformls",
	"tflint",
	"bashls",
	"gopls",
}

local nvlsp = require("nvchad.configs.lspconfig")

-- Configure servers using new vim.lsp.config API
for _, lsp in ipairs(servers) do
	vim.lsp.config(lsp, {
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
	})
	vim.lsp.enable(lsp)
end

-- Terraform with custom capabilities
local tf_capb = vim.lsp.protocol.make_client_capabilities()
tf_capb.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.config('terraformls', {
	on_attach = nvlsp.on_attach,
	flags = { debounce_text_changes = 150 },
	capabilities = tf_capb,
})
vim.lsp.enable('terraformls')
