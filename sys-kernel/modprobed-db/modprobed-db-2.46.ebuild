# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Keeps track of EVERY kernel module ever used - useful for make localmodconfig"
HOMEPAGE="https://github.com/graysky2/modprobed-db"
SRC_URI="https://github.com/graysky2/modprobed-db/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="sys-apps/kmod
	sys-apps/systemd"

RESTRICT="mirror"

