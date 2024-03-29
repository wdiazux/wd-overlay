# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info unpacker xdg-utils tmpfiles

MY_PV=${PV/-/_}

DESCRIPTION="NordVPN CLI tool for Linux"
HOMEPAGE="https://nordvpn.com"
BASE_URI="https://repo.nordvpn.com/deb/${PN}/debian/pool/main"
SRC_URI="
	amd64? ( ${BASE_URI}/${PN}_${MY_PV}_amd64.deb )
	arm64? ( ${BASE_URI}/${PN}_${MY_PV}_arm64.deb )"

LICENSE="NordVPN"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="nordlynx systemd"
RESTRICT="mirror strip"

RDEPEND="
	acct-group/nordvpn
	dev-libs/libxslt[crypt]
	net-firewall/iptables
	sys-apps/iproute2[iptables]
	sys-process/procps
	systemd? (
		sys-apps/systemd
	)"

S="${WORKDIR}"

QA_PREBUILT="usr/*
	var/lib/${PN}/*"

pkg_setup() {
	CONFIG_CHECK="
		~CONFIG_IP_MULTIPLE_TABLES
	"

	if use nordlynx; then
		CONFIG_CHECK+="
			~WIREGUARD
		"
	fi
}

src_prepare() {
	default

	if use !systemd; then
		rm -rf usr/lib || die
	fi

	gzip "${S}"/usr/share/doc/nordvpn/changelog.gz -d "${S}"
	gzip "${S}"/usr/share/man/man1/nordvpn.1.gz -d "${S}"
}

src_install() {
	cd ${S}

	use !systemd && newinitd "${FILESDIR}/${PN}.initd ${PN}"

	dobin usr/bin/nordvpn
	dosbin usr/sbin/nordvpnd

	insinto /var/lib/
	doins -r var/lib/nordvpn

	if use systemd ; then
		insinto /usr/lib/
		doins -r usr/lib/systemd
	fi

	fowners root:nordvpn /var/lib/nordvpn/openvpn
	fperms 0550 /var/lib/nordvpn/openvpn

	insinto /usr/share/
	doins -r usr/share/applications
	doins -r usr/share/zsh
	doins -r usr/share/bash-completion
	doins -r usr/share/icons

	dodoc usr/share/doc/nordvpn/changelog
	doman usr/share/man/man1/nordvpn.1

	dotmpfiles "${FILESDIR}/nordvpn.conf"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	tmpfiles_process nordvpn.conf
}

pkg_postrm (){
	xdg_desktop_database_update
	xdg_icon_cache_update
}
