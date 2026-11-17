#!/usr/bin/env bash
#
# Move para o backup o que estiver no caminho dos dotfiles antes do `dotdrop install -f`
# (com -f o dotdrop apaga arquivos e diretórios existentes sem backup).
#
# Uso: dotdrop files -G -p <perfil> | backup-conflicts.sh <backup_dir>
# Lê linhas "chave,dst:<destino>,src:<origem>,..." e imprime "backup: ..." para cada item movido.
# Um destino que já resolve para o arquivo do repositório não é conflito.

set -euo pipefail

backup_dir="$1"

while IFS= read -r line; do
	[[ "$line" == *",dst:"*",src:"* ]] || continue
	dst="${line#*,dst:}"
	dst="${dst%%,src:*}"
	src="${line#*,src:}"
	src="${src%%,link:*}"

	[[ -e "$dst" || -L "$dst" ]] || continue
	[[ "$(realpath -m "$dst")" == "$(realpath -m "$src")" ]] && continue

	rel="${dst#"$HOME"/}"
	mkdir -p "$backup_dir/$(dirname "$rel")"
	mv "$dst" "$backup_dir/$rel"
	echo "backup: ~/$rel -> $backup_dir/$rel"
done
