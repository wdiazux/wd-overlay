# Copyright 2020 William Diaz <william@wdiaz.org>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils

MY_PN="vscode"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Multiplatform Visual Studio Code from Microsoft (binary version)"
HOMEPAGE="https://code.visualstudio.com"
BASE_URI="https://update.code.visualstudio.com/${PV}"
SRC_URI="
	amd64? ( ${BASE_URI}/linux-x64/stable -> ${P}-amd64.tar.gz )
	"
RESTRICT="mirror strip bindist"

LICENSE="MS-vscode-EULA"
SLOT="0"
KEYWORDS="~amd64"
IUSE="global-menu libsecret qt5"

DEPEND="
	>=media-libs/libpng-1.2.46
	>=x11-libs/gtk+-2.24.8-r1:2
	x11-libs/cairo
	gnome-base/gconf
	sys-process/lsof
	x11-libs/libXtst
	!app-editors/vscode
"

RDEPEND="
	${DEPEND}
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	dev-libs/nss
	libsecret? ( app-crypt/libsecret[crypt] )
	global-menu? (
		dev-libs/libdbusmenu
		qt5? (
			dev-libs/libdbusmenu-qt
		)
	)
"

DOCS=( resources/app/LICENSE.rtf )

QA_PRESTRIPPED="opt/${MY_PN}/code"
QA_PREBUILT="opt/${MY_PN}/code"

pkg_setup(){
	use amd64 && S="${WORKDIR}/VSCode-linux-x64"
	use x86 && S="${WORKDIR}/VSCode-linux-ia32"
}

src_install(){
	pax-mark m code
	insinto "/opt/${PN}"
	doins -r *
	fperms +x "/opt/${PN}/code"
	fperms +x "/opt/${PN}/bin/code"
	fperms +x "/opt/${PN}/resources/app/node_modules.asar.unpacked/vscode-ripgrep/bin/rg"
	fperms +x "/opt/${PN}/resources/app/extensions/git/dist/askpass.sh"
	dosym "/opt/${PN}/bin/code" "/usr/bin/${MY_PN}"
	make_desktop_entry "${MY_PN}" "Visual Studio Code" "${MY_PN}" "Utility;TextEditor;Development;IDE;"
	make_desktop_entry "${MY_PN}-url-handler" "Visual Studio Code - URL Handler" "${MY_PN}" "Utility;TextEditor;Development;IDE;"
	newicon "resources/app/resources/linux/code.png" ${MY_PN}.png
	einstalldocs
}

pkg_postinst(){
	elog "You may install some additional components, so check them in:"
	elog "https://code.visualstudio.com/docs/setup/additional-components"
}
