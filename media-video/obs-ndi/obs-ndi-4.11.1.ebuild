# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Network A/V in OBS Studio with NewTek's NDI technology"
HOMEPAGE="https://github.com/Palakis/obs-ndi"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="qt6"

DEPEND="
	qt6? ( dev-qt/qtbase:6 )
	!qt6? ( dev-qt/qtcore:5 )
	>=media-video/obs-studio-28
	>=media-video/ndi-sdk-bin-5"
RDEPEND="${DEPEND}"
RESTRICT="mirror"

PATCHES="${FILESDIR}/${PN}-install.patch"

