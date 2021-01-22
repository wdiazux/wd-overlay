# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info cmake

DESCRIPTION="Unofficial driver for Logitech devices"
HOMEPAGE="https://github.com/PixlOne/logiops"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PixlOne/logiops.git"
	S="${WORKDIR}/${PN}-${PV}"
else
	SRC_URI="https://github.com/PixlOne/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror"

RDEPEND="dev-libs/libevdev
	virtual/libudev
	dev-libs/libconfig"

DEPEND="${RDEPEND}"
BDEPEND="dev-util/cmake"

pkg_pretend() {
	local CHECK_CONFIG="~HID_LOGITECH ~HID_LOGITECH_HIDPP ~INPUT_UINPUT"
	check_extra_config
}

pkg_postinst() {
	elog "NOTE: The installed systemd daemon is called 'logid'."
	elog "WARNING: No configuration file is included!"
	elog "See https://github.com/PixlOne/logiops/wiki/Configuration"
}

