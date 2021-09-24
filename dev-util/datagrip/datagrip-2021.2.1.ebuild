# Copyright 1999-2020 William Diaz <william@wdiaz.org>
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop eutils

DESCRIPTION="Smart SQL Editor and Advanced Database Client Packed Together"
HOMEPAGE="https://www.jetbrains.com/datagrip"
SRC_URI="https://download.jetbrains.com/${PN}/${P}.tar.gz"

LICENSE="|| ( IDEA IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )
	Apache-1.1 Apache-2.0 BSD BSD-2 CC0-1.0 CDDL-1.1 CPL-0.5 CPL-1.0
	EPL-1.0 EPL-2.0 GPL-2 GPL-2-with-classpath-exception GPL-3 ISC JDOM
	LGPL-2.1+ LGPL-3 MIT MPL-1.0 MPL-1.1 OFL public-domain PSF-2 UoI-NCSA ZLIB"
SLOT="0"
VER="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~x86"
RESTRICT="bindist mirror splitdebug"
IUSE="custom-jdk"

# RDEPENDS may cause false positives in repoman.
# clion requires cmake and gdb at runtime to build and debug C/C++ projects
RDEPEND="
	dev-libs/libdbusmenu
	dev-util/cmake
	sys-devel/gdb
	!custom-jdk? ( virtual/jdk )"

QA_PREBUILT="opt/${P}/*"

src_prepare() {
	default

	local remove_me=(
		bin/gdb/linux
		bin/lldb/linux
		bin/cmake
		license/CMake*
		lib/pty4j-native/linux/ppc64le
	)

	use amd64 || remove_me+=( lib/pty4j-native/linux/x86_64)
	use x86 || remove_me+=( lib/pty4j-native/linux/x86)

	use custom-jdk || remove_me+=( jbr )

	rm -rv "${remove_me[@]}" || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{${PN}.sh,clang/linux/clang{d,-tidy}}
	fperms 755 "${dir}"/bin/fsnotifier

	if use custom-jdk; then
		if [[ -d jbr ]]; then
		fperms 755 "${dir}"/jbr/bin/{jaotc,java,javac,jdb,jjs,jrunscript,keytool,pack200,rmid,rmiregistry,serialver,unpack200}
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "CLion ${VER}" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	dodir /usr/lib/sysctl.d/
	echo "fs.inotify.max_user_watches = 524288" > "${D}/usr/lib/sysctl.d/30-${PN}-inotify-watches.conf" || die
}