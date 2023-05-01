# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop

FILE_NAME="Install_NDI_SDK_v5_Linux.sh"

DESCRIPTION="NewTek NDI SDK"
HOMEPAGE="https://ndi.tv/sdk/"
SRC_URI="https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v5_Linux.tar.gz -> ${P}.tar.gz"

LICENSE="NDI_EULA_END"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="net-dns/avahi[dbus]"
BDEPEND="media-gfx/icoutils"
RESTRICT="bindist mirror"

S="${WORKDIR}/NDI SDK for Linux"

src_unpack() {
	unpack ${A}
	ARCHIVE=`awk '/^__NDI_ARCHIVE_BEGIN__/ { print NR+1; exit 0; }' "${WORKDIR}/${FILE_NAME}"`
	tail -n+$ARCHIVE "${WORKDIR}/${FILE_NAME}" | tar xvz
}

src_prepare() {
	default

	mkdir icons

	local _icon
	for _icon in `ls logos/*.ico`; do
		icotool -x "${_icon}" -o icons 2>/dev/null
	done
}

src_install() {
	dolib.so "${S}/lib/x86_64-linux-gnu/libndi.so.${PV}"
	dosym "libndi.so.${PV}" "/usr/$(get_libdir)/libndi.so.5"
	dosym "libndi.so.5" "/usr/$(get_libdir)/libndi.so"
	for header in `ls "${S}/include/"`; do
		doheader "${S}/include/${header}"
	done

	local _icon
	local _name
	local _res
	local _sres="16 22 24 32 36 48 64 72 96 128 192 256 512 1024"
	for _icon in `ls icons/*x32.png`; do
		_name="$(sed 's|^.*/||;s/_[0-9]*_[0-9]*x[0-9]*x[0-9]*\.png//' <<< ${_icon})"
		_res="$(sed 's/\.png$//;s/^.*_//;s/x.*$//' <<< ${_icon})"
		if $(echo ${_sres} | grep -w -q ${_res}); then
			newicon -s "${_res}" "${_icon}" "${_name}.png" || die
		fi
	done

	dobin bin/x86_64-linux-gnu/*

	dodoc -r documentation/*
}

