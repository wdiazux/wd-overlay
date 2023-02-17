# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
KEYWORDS="~amd64"
RESTRICT="bindist mirror strip"

IUSE="+policykit"

RDEPEND="
	dev-libs/nss
	policykit? ( sys-auth/polkit )
	x11-libs/gtk+:3
	x11-libs/libXScrnSaver"

S="${WORKDIR}/${MY_P}"
QA_PREBUILT="*"

src_prepare() {
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

	default
}

src_install() {
	local size
	local ONE_PASSWORD_HOME="/opt/1Password"

	for size in 32x32 64x64 256x256 512x512; do
		doicon -s "${size}" "resources/icons/hicolor/${size}/apps/${PN}.png"
	done
	rm -r resources/icons/

	domenu "${S}/resources/${PN}.desktop"
	rm resources/1password.desktop resources/custom_allowed_browsers

	if use policykit; then
		insinto "/usr/share/polkit-1/actions/"
		doins "${S}"/com.1password.1Password.policy
	fi
	rm com.1password.1Password.policy com.1password.1Password.policy.tpl install_biometrics_policy.sh

	dodir ${ONE_PASSWORD_HOME}
	insinto ${ONE_PASSWORD_HOME}
	doins -r *

	dosym "${ONE_PASSWORD_HOME}/${PN}" /usr/bin/${PN}

	fperms +x "${ONE_PASSWORD_HOME}/${PN}"

	fperms 4755 "${ONE_PASSWORD_HOME}/chrome-sandbox"
}
