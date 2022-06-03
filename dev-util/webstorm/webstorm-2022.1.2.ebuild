# Copyright 2022 William Diaz <william@wdiaz.org>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

DESCRIPTION="The smartest JavaScript IDE"
HOMEPAGE="https://www.jetbrains.com/webstorm"
SRC_URI="https://download.jetbrains.com/webstorm/WebStorm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( IDEA IDEA_Academic IDEA_Classroom IDEA_OpenSource IDEA_Personal )
	Apache-1.1 Apache-2.0 BSD BSD-2 CC0-1.0 CDDL-1.1 CPL-0.5 CPL-1.0
	EPL-1.0 EPL-2.0 GPL-2 GPL-2-with-classpath-exception GPL-3 ISC JDOM
	LGPL-2.1+ LGPL-3 MIT MPL-1.0 MPL-1.1 OFL public-domain PSF-2 UoI-NCSA ZLIB"
SLOT="0"
VER="$(ver_cut 1-2)"
KEYWORDS="~amd64 ~arm64"
RESTRICT="strip bindist mirror splitdebug"
IUSE="custom-jdk"

BDEPEND="dev-util/patchelf"

RDEPEND="
	app-accessibility/at-spi2-atk:2
	app-accessibility/at-spi2-core:2
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libdbusmenu
	!custom-jdk? ( virtual/jdk )"

BUILD_NUMBER="221.5787.30"

S="${WORKDIR}/WebStorm-${BUILD_NUMBER}"

QA_PREBUILT="opt/${P}/*"

src_prepare() {
	default

	local remove_me=(
		lib/pty4j-native/linux/x86
		lib/pty4j-native/linux/arm
		lib/pty4j-native/linux/mips64el
		lib/pty4j-native/linux/ppc64le
		plugins/remote-dev-server/selfcontained
	)

	use amd64 || remove_me+=( lib/pty4j-native/linux/x86_64)
	use arm64 || remove_me+=( lib/pty4j-native/linux/aarch64)

	use custom-jdk || remove_me+=( jbr )

	rm -rv "${remove_me[@]}" || die

	for file in "jbr/lib/"/{libjcef.so,jcef_helper}
	do
		if [[ -f "${file}" ]]; then
			patchelf --set-rpath '$ORIGIN' ${file} || die
		fi
	done

	sed -i \
		-e "\$a\\\\" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$a# Disable automatic updates as these are handled through Gentoo's" \
		-e "\$a# package manager. See bug #704494" \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/${PN}.sh
	fperms 755 "${dir}"/bin/fsnotifier

	if use custom-jdk; then
		if [[ -d jbr ]]; then
			fperms 755 "${dir}"/jbr/bin/{jaotc,java,javac,jdb,jjs,jrunscript,keytool,pack200,rmid,rmiregistry,serialver,unpack200}

			# Fix #763582
			fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "WebStorm ${VER}" "${PN}" "Development;IDE;WebDevelopment;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	dodir /usr/lib/sysctl.d/
	echo "fs.inotify.max_user_watches = 524288" > "${D}/usr/lib/sysctl.d/30-${PN}-inotify-watches.conf" || die
}
