-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require("lspconfig")

-- EXAMPLE
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

-- lsps with default config
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_attach = nvlsp.on_attach,
		on_init = nvlsp.on_init,
		capabilities = nvlsp.capabilities,
	})
end

local tf_capb = vim.lsp.protocol.make_client_capabilities()
tf_capb.textDocument.completion.completionItem.snippetSupport = true

lspconfig.terraformls.setup({
	on_attach = nvlsp.on_attach,
	flags = { debounce_text_changes = 150 },
	capabilities = tf_capb,
})
