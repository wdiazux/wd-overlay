# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

if [[ ${PV} != ${PV/beta/} ]] || [[ ${PV} != ${PV/alpha/} ]]; then
	MYPAINT_PV=$( ver_rs 3 - 4 .)
else
	MYPAINT_PV=${PV}
fi

DESCRIPTION="Default MyPaint brushes"
HOMEPAGE="https://github.com/Jehan/mypaint-brushes"
SRC_URI="https://github.com/mypaint/${PN}/archive/v${MYPAINT_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0 GPL-2 GPL-3"
SLOT="2.0"  # due to pkgconfig name "mypaint-brushes-1.0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DOCS=( AUTHORS NEWS README.md )  # to exclude README symlink

S=${WORKDIR}/${PN}-${MYPAINT_PV}

src_prepare() {
	default
	eapply_user
	eautoreconf
}
