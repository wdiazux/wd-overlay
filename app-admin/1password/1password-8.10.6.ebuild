# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CHROMIUM_LANGS="
	am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk vi zh-CN zh-TW"

inherit chromium-2 desktop pax-utils verify-sig xdg

MY_P="${P}.x64"

DESCRIPTION="Password manager and secure wallet"
HOMEPAGE="https://1password.com"
SRC_URI="https://downloads.1password.com/linux/tar/stable/x86_64/${MY_P}.tar.gz
	https://downloads.1password.com/linux/tar/stable/x86_64/${MY_P}.tar.gz.sig"

LICENSE="LicenseRef-1Password-Proprietary"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="bindist mirror splitdebug test"

IUSE="+policykit appindicator wayland"

DEPEND="acct-group/onepassword"
BDEPEND="
	${DEPEND}
	verify-sig? ( sec-keys/openpgp-keys-1password )"

RDEPEND="
	${DEPEND}
	appindicator? ( dev-libs/libappindicator )
	policykit? ( sys-auth/polkit )
	app-crypt/gnupg
	dev-libs/nss
	net-misc/curl
	virtual/libudev
	x11-libs/gtk+:3
	x11-libs/libXScrnSaver
	x11-themes/hicolor-icon-theme"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/1password.com.asc

S="${WORKDIR}/${MY_P}"
QA_PREBUILT="*"

MY_PKG_HELPER="1Password-KeyringHelper"
MY_PKG_BROWSER_SUPPORT="1Password-BrowserSupport"

src_prepare() {
	default

	rm LICENSE.electron.txt LICENSES.chromium.html || die
	rm after-install.sh after-remove.sh || die

	pushd "locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	if use policykit; then
		# Fill in policy kit file with a list of (the first 10) human users of the system.
		export POLICY_OWNERS
		POLICY_OWNERS="$(cut -d: -f1,3 /etc/passwd | grep -E ':[0-9]{4}$' | cut -d: -f1 | head -n 10 | sed 's/^/unix-user:/' | tr '\n' ' ')"
		eval "cat <<EOF
$(cat ./com.1password.1Password.policy.tpl)
EOF" > ./com.1password.1Password.policy
	fi

	if use wayland; then
		cp "resources/${PN}.desktop" "resources/${PN}-wayland.desktop" || die
		sed -i "s/Name=.*/\0 Wayland/g" "resources/${PN}-wayland.desktop" || die
		sed -i "s/Exec=.*/\0 --enable-features=WaylandWindowDecorations --ozone-platform-hint=auto/g" "resources/${PN}-wayland.desktop" || die
	fi
}

src_install() {
	local size
	local ONE_PASSWORD_HOME="/opt/1Password"

	insinto /etc/${PN}
	doins ./resources/custom_allowed_browsers
	rm ./resources/custom_allowed_browsers || die

	domenu "${S}/resources/${PN}.desktop"
	rm resources/${PN}.desktop || die

	if use wayland; then
		domenu "${S}/resources/${PN}-wayland.desktop" || die
		rm resources/${PN}-wayland.desktop || die
	fi

	if use policykit; then
		insinto "/usr/share/polkit-1/actions/"
		doins "${S}"/com.1password.1Password.policy
	fi
	rm com.1password.1Password.policy com.1password.1Password.policy.tpl install_biometrics_policy.sh || die

	for size in 32x32 64x64 256x256 512x512; do
		doicon -s "${size}" "resources/icons/hicolor/${size}/apps/${PN}.png"
	done
	rm -r resources/icons/ || die

	dodir ${ONE_PASSWORD_HOME}
	insinto ${ONE_PASSWORD_HOME}
	doins -r *

	pax-mark m ${PN}
	fperms +x "${ONE_PASSWORD_HOME}/${PN}"
	fperms 6755 "${ONE_PASSWORD_HOME}/${MY_PKG_HELPER}"
	fperms 2755 "${ONE_PASSWORD_HOME}/${MY_PKG_BROWSER_SUPPORT}"
	fperms 4755 "${ONE_PASSWORD_HOME}/chrome-sandbox"
	fperms +x "${ONE_PASSWORD_HOME}/chrome_crashpad_handler"
	fowners 0:onepassword "${ONE_PASSWORD_HOME}/${MY_PKG_HELPER}"
	fowners 0:onepassword  "${ONE_PASSWORD_HOME}/${MY_PKG_BROWSER_SUPPORT}"
	dosym "${ONE_PASSWORD_HOME}/${PN}" /usr/bin/${PN}

	fperms +x "${ONE_PASSWORD_HOME}/${PN}"
}
