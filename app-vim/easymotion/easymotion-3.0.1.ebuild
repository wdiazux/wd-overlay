# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIM_PLUGIN_VIM_VERSION="7.0"
inherit vim-plugin vcs-snapshot

DESCRIPTION="vim plugin: Vim motions on speed!"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=3526"
SRC_URI="https://github.com/easymotion/vim-easymotion/tarball/v${PV} -> ${P}.tar.gz"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

VIM_PLUGIN_HELPFILES="${PN}"

src_install() {
	dodoc README.md
	rm .gitignore README.md
	vim-plugin_src_install
}
