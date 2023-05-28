# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Patched font Fira (Fura) Code from nerd fonts library"
HOMEPAGE="https://github.com/ryanoasis/nerd-fonts"
SRC_URI="https://github.com/ryanoasis/nerd-fonts/releases/download/v${PV}/FiraCode.tar.xz -> ${P}.tar.xz"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~x64-macos"

RESTRICT="mirror"

S="${WORKDIR}"

FONT_CONF=( "${FILESDIR}"/90-firacode-nerdfont.conf )
FONT_SUFFIX="ttf"

