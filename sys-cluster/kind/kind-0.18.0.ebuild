# Copyright 2023 William Diaz <william@wdiaz.org>
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module bash-completion-r1
GIT_COMMIT=877adac953a25ea9b2e9bfe4e1624fb6be8d6e7d

DESCRIPTION="Run local Kubernetes cluster in Docker"
HOMEPAGE="https://kind.sigs.k8s.io/"
SRC_URI="https://github.com/kubernetes-sigs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	http://wdiaz.org/content/files/distfiles/${P}-vendor.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+docker podman bash-completion zsh-completion fish-completion"

DEPEND=">=dev-lang/go-1.17.0
	sys-cluster/kubectl"
RDEPEND="
	docker? ( >=app-containers/docker-20.10.0 )
	podman? (
		>=app-containers/podman-3.0.0
		net-dns/dnsmasq
	)
	zsh-completion? ( app-shells/zsh )
	fish-completion? ( app-shells/fish )
	"
RESTRICT="test bindist mirror strip"

src_compile() {
	ego build

	use bash-completion && bin/${PN} completion bash > ${PN}.bash
	use fish-completion && bin/${PN} completion fish > ${PN}.fish
	use zsh-completion && bin/${PN} completion zsh > ${PN}.zsh
}

src_install() {
	use bash-completion && newbashcomp ${PN}.bash ${PN}

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins ${PN}.zsh _${PN} || die "Failed to install zsh-completions"
	fi

	if use fish-completion ; then
		insinto /usr/share/fish/vendor_completions.d
		doins ${PN}.fish || die "Failed to install fish-completions"
	fi

	dobin ${PN}
}
