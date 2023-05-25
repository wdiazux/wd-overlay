# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake linux-info

DESCRIPTION="An unofficial userspace driver for HID++ Logitech devices"
HOMEPAGE="https://github.com/PixlOne/logiops"

if [[ "${PV}" == 9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PixlOne/logiops.git"
else
	SRC_URI="https://github.com/PixlOne/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="systemd"
RESTRICT="mirror"

DEPEND="
	dev-libs/glib
	dev-libs/libconfig:=[cxx]
	dev-libs/libevdev
	sys-apps/dbus
	virtual/libudev
	systemd? ( sys-apps/systemd )
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( "README.md" "TESTED.md" )

pkg_pretend() {
	local CHECK_CONFIG="~HID_LOGITECH ~HID_LOGITECH_HIDPP ~INPUT_UINPUT"
	check_extra_config
}

src_install() {
	default

	cmake_src_install

	# Install lib of submodule, as no install routine exist
	dolib.so "${BUILD_DIR}/src/ipcgull/libipcgull.so"

	insinto /etc
	newins logid.example.cfg logid.cfg
	newinitd "${FILESDIR}"/logid.initd logid
}

pkg_postinst() {
	einfo "An example config file has been installed as /etc/logid.cfg."
	einfo "See https://github.com/PixlOne/logiops/wiki/Configuration for more information."
}

