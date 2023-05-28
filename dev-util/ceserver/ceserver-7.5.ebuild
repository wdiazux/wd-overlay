# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cheat Engine Server"
HOMEPAGE="https://github.com/cheat-engine/cheat-engine/tree/master/Cheat%20Engine/ceserver"
SRC_URI="https://github.com/cheat-engine/cheat-engine/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CUSTOM"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

S="${WORKDIR}/cheat-engine-${PV}/Cheat Engine/ceserver/gcc"

src_install() {
	dobin ceserver
}
