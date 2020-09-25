# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"
MY_P="${MY_PN}-${PV}"

inherit desktop gnome2-utils unpacker xdg-utils

DESCRIPTION="Yet another keyboard configurator"
HOMEPAGE="https://github.com/olivia/via-config-private#readme"
SRC_URI="https://github.com/the-${MY_PN}/releases/releases/download/v${PV}/${MY_P}-linux.deb"

LICENSE="CUSTOM"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="appindicator"

DEPEND="
	x11-themes/hicolor-icon-theme
	x11-libs/gtk+:3
	x11-libs/libnotify
	dev-libs/nss
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-misc/xdg-utils
	app-accessibility/at-spi2-core:2
	sys-apps/util-linux
	appindicator? ( dev-libs/libappindicator:3 )
	app-crypt/libsecret"
RDEPEND="${DEPEND}"
BDEPEND=""

QA_PREBUILT="
	opt/VIA/via
	opt/VIA/libffmpeg.so
	opt/VIA/libGLESv2.so
	opt/VIA/libEGL.so
	opt/VIA/swiftshader/libvk_swiftshader.so
	opt/VIA/swiftshader/libGLESv2.so
	opt/VIA/swiftshader/libEGL.so
"

S="${WORKDIR}"

src_install() {
	insinto /opt
	doins -r opt/.
	fperms +x /opt/VIA/via

	domenu usr/share/applications/via.desktop
	dosym /opt/VIA/via /usr/bin/via

	insinto /usr/share/icons
	doins -r usr/share/icons/.
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
