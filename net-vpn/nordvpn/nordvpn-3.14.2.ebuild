# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info unpacker

MY_PV=${PV/-/_}

DESCRIPTION="NordVPN CLI tool for Linux"
HOMEPAGE="https://nordvpn.com"
BASE_URI="https://repo.nordvpn.com/deb/${PN}/debian/pool/main"
SRC_URI="
	amd64? ( ${BASE_URI}/${PN}_${MY_PV}_amd64.deb )
	arm? ( ${BASE_URI}/${PN}_${MY_PV}_armhf.deb )
	arm64? ( ${BASE_URI}/${PN}_${MY_PV}_arm64.deb )
	x86? ( ${BASE_URI}/${PN}_${MY_PV}_i386.deb )"

LICENSE="NordVPN"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="ipsymlink nordlynx systemd"
RESTRICT="mirror strip"

RDEPEND="
	acct-group/nordvpn
	dev-libs/libxslt[crypt]
	net-firewall/iptables
	sys-apps/iproute2[iptables]
	sys-process/procps
	nordlynx? (
		net-vpn/wireguard-modules
		net-vpn/wireguard-tools
	)
	systemd? (
		sys-apps/systemd
	)"

S="${WORKDIR}"

pkg_pretend() {
	if use nordlynx && kernel_is -ge 5 6; then
		eerror "You enabled the nordlynx USE-flag and"
		eerror "have a kernel >= 5.6, so this is not needed"
		eerror "because the wireguard-modules built into the"
		eerror "kernel. Please, disable it."
	fi
}

src_prepare() {
	default

	rm _gpgbuilder || die
	if use !systemd; then
		rm -rf usr/lib || die
	fi

	gzip "${S}"/usr/share/doc/nordvpn/changelog.gz -d "${S}"
	gzip "${S}"/usr/share/man/man1/nordvpn.1.gz -d "${S}"
}

src_install() {
	cd ${S}

	dobin usr/bin/nordvpn
	dosbin usr/sbin/nordvpnd

	use !systemd && newinitd "${FILESDIR}/${PN}d ${PN}"

	insinto /var/lib/
	doins -r var/lib/nordvpn

	if use systemd ; then
		insinto /usr/lib/
		doins -r usr/lib/systemd
	fi

	fowners root:nordvpn /var/lib/nordvpn/openvpn
	fperms 0550 /var/lib/nordvpn/openvpn

	insinto /usr/share/bash-completion/completions
	doins usr/share/bash-completion/completions/nordvpn

	dodoc usr/share/doc/nordvpn/changelog
	doman usr/share/man/man1/nordvpn.1

	use ipsymlink && dosym /bin/ip /sbin/ip

	insinto /usr/lib/tmpfiles.d
	doins "${FILESDIR}/nordvpn.conf"
}

pkg_postinst() {
	if use !ipsymlink ; then
		elog "nordvpnd expects to find ip command in /sbin folder iproute2 package installs it in /bin please make sure to create a symlink: ln -s /bin/ip /sbin/ip"
	fi
}