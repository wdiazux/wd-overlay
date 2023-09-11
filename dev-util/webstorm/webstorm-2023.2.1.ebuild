# Copyright 2023 William Diaz <william@wdiaz.org>
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
	>=app-accessibility/at-spi2-core-2.46.0:2
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/libdbusmenu
	media-libs/alsa-lib
	media-libs/freetype:2
	media-libs/mesa
	sys-apps/dbus
	x11-libs/cairo
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/libXxf86vm
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/pango
	!custom-jdk? ( virtual/jdk )"

BUILD_NUMBER="232.9559.58"

S="${WORKDIR}/WebStorm-${BUILD_NUMBER}"

QA_PREBUILT="opt/${P}/*"

src_prepare() {
	default

	local remove_me=(
		help/ReferenceCardForMac.pdf
		plugins/cwm-plugin/quiche-native/darwin-aarch64
		plugins/cwm-plugin/quiche-native/darwin-x86-64
		plugins/cwm-plugin/quiche-native/win32-x86-64
		plugins/remote-dev-server/selfcontained
	)

	use amd64 || remove_me+=( plugins/cwm-plugin/quiche-native/linux-aarch64)
	use arm64 || remove_me+=( plugins/cwm-plugin/quiche-native/linux-x86-64)

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
		-e "\$a# package manager." \
		-e "\$a#-----------------------------------------------------------------------" \
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{${PN}.sh,fsnotifier,inspect.sh,ltedit.sh,repair,restart.py}

	if use custom-jdk; then
		if [[ -d jbr ]]; then
			fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,keytool,rmiregistry,serialver}

			# Fix #763582
			fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${PN}.sh"
	newicon "bin/${PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "WebStorm ${VER}" "${PN}" "Development;IDE;WebDevelopment;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	insinto /usr/lib/sysctl.d
	newins - 30-"${PN}"-inotify-watches.conf <<<"fs.inotify.max_user_watches = 524288"
}
