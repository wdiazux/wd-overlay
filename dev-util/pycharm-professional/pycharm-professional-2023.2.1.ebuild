# Copyright 2023 William Diaz <william@wdiaz.org>
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop wrapper

MY_PN=${PN/-professional/}

DESCRIPTION="Intelligent Python IDE with unique code assistance and analysis"
HOMEPAGE="https://www.jetbrains.com/pycharm/"
SRC_URI="https://download.jetbrains.com/python/${P}.tar.gz"

LICENSE="PyCharm_Academic PyCharm_Classroom PyCharm PyCharm_OpenSource PyCharm_Preview"
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

BUILD_NUMBER="231.8770.64"

S="${WORKDIR}/${MY_PN}-${PV}"

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
		-e "\$aide.no.platform.update=Gentoo"  bin/idea.properties || die
}

src_install() {
	local dir="/opt/${P}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}"/bin/{${MY_PN}.sh,format.sh,fsnotifier,inspect.sh,ltedit.sh,repair,restart.py}

	if use custom-jdk; then
		if [[ -d jbr ]]; then
			fperms 755 "${dir}"/jbr/bin/{java,javac,javadoc,jcmd,jdb,jfr,jhsdb,jinfo,jmap,jps,jrunscript,jstack,jstat,keytool,rmiregistry,serialver}

			# Fix #763582
			fperms 755 "${dir}"/jbr/lib/{chrome-sandbox,jcef_helper,jexec,jspawnhelper}
		fi
	fi

	make_wrapper "${PN}" "${dir}/bin/${MY_PN}.sh"
	newicon "bin/${MY_PN}.svg" "${PN}.svg"
	make_desktop_entry "${PN}" "PyCharm ${VER}" "${PN}" "Development;IDE;"

	# recommended by: https://confluence.jetbrains.com/display/IDEADEV/Inotify+Watches+Limit
	insinto /usr/lib/sysctl.d
	newins - 30-"${PN}"-inotify-watches.conf <<<"fs.inotify.max_user_watches = 524288"
}
