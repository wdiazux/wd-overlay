# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB en-US es es-419 et fa fi fil fr gu he hi
	hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr sv
	sw ta te th tr uk vi zh-CN zh-TW"

inherit desktop chromium-2 pax-utils xdg

MY_P="${P}.x64"

DESCRIPTION="Password manager and secure wallet"
HOMEPAGE="https://1password.com"
SRC_URI="https://downloads.1password.com/linux/tar/stable/x86_64/${MY_P}.tar.gz"

LICENSE="LicenseRef-1Password-Proprietary"
SLOT="0"
KEYWORDS="-* ~amd64"
RESTRICT="bindist mirror strip"

RDEPEND="
	dev-libs/nss
	sys-auth/polkit
	x11-libs/gtk+:3
	x11-libs/libXScrnSaver"

S="${WORKDIR}/${MY_P}"
QA_PREBUILT="*"

src_prepare() {
	pushd locales > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	default
}

src_install() {
	local size
	local ONE_PASSWORD_HOME="/opt/1Password"

	for size in 32x32 64x64 256x256 512x512; do
		doicon -s "${size}" "resources/icons/hicolor/${size}/apps/${PN}.png"
	done

	domenu "${S}/resources/${PN}.desktop"

	dodir ${ONE_PASSWORD_HOME}
	insinto ${ONE_PASSWORD_HOME}
	doins -r *

	insinto "/usr/share/polkit-1/actions/"
	doins "${S}"/com.1password.1Password.policy

	dosym "${ONE_PASSWORD_HOME}/${PN}" /usr/bin/${PN}

	fperms +x "${ONE_PASSWORD_HOME}/${PN}"
}
