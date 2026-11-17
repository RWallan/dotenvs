-- Rust: versões, features e completion de dependências no Cargo.toml.
-- Usa um LSP em processo, então o completion aparece direto no blink.cmp.
return {
	"saecki/crates.nvim",
	tag = "stable",
	event = { "BufRead Cargo.toml" },
	opts = {
		completion = {
			crates = { enabled = true },
		},
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	},
}
