# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Network A/V in OBS Studio with NewTek's NDI technology"
HOMEPAGE="https://github.com/Palakis/obs-ndi"
SRC_URI="https://github.com/Palakis/${PN}/archive/dummy-tag-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="media-video/ndi-sdk
		media-video/obs-studio"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-util/cmake-3.5"
RESTRICT="mirror"

S="${WORKDIR}/${PN}-dummy-tag-${PV}"
