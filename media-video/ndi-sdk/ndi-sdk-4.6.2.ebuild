# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

FILE_NAME="InstallNDISDK_v4_Linux.sh"

DESCRIPTION="NewTek NDI SDK"
HOMEPAGE="https://ndi.tv/sdk/"
SRC_URI="http://new.tk/NDISDKLINUX -> ${P}.tar.gz"

LICENSE="NDI_EULA_END"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="net-dns/avahi[dbus]
		${DEPEND}"
BDEPEND=""
RESTRICT="bindist mirror"

S="${WORKDIR}/NDI SDK for Linux"

src_unpack() {
	unpack ${A}
	ARCHIVE=`awk '/^__NDI_ARCHIVE_BEGIN__/ { print NR+1; exit 0; }' "${WORKDIR}/${FILE_NAME}"`
	tail -n+$ARCHIVE "${WORKDIR}/${FILE_NAME}" | tar xvz
}

src_install() {
	if use amd64; then
		dolib.so "${S}/lib/x86_64-linux-gnu/libndi.so.${PV}"
	fi
	dosym "libndi.so.${PV}" "/usr/$(get_libdir)/libndi.so.4"
	dosym "libndi.so.4" "/usr/$(get_libdir)/libndi.so"
	for header in `ls "${S}/include/"`; do
		doheader "${S}/include/${header}"
	done
}

