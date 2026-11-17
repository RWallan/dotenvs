-- Parsers do treesitter instalados automaticamente.
-- Também usado pelo setup_arch.sh para pré-instalar tudo em modo headless.
return {
	-- Neovim / shell
	"bash",
	"diff",
	"lua",
	"luadoc",
	"vim",
	"vimdoc",
	"markdown",
	"markdown_inline",

	-- Dados / config
	"json",
	"yaml",
	"toml",
	"sql",
	"dockerfile",

	-- Python
	"python",

	-- Web / Svelte
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"svelte",

	-- Rust
	"rust",

	-- Go
	"go",
	"gomod",
	"gosum",
	"gowork",
}
