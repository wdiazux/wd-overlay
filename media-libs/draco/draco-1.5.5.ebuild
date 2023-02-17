# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A library for compressing and decompressing 3D geometric meshes and point clouds"
HOMEPAGE="https://google.github.io/draco/"
SRC_URI="https://github.com/google/draco/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+compat -gltf -usd"

RDEPEND="usd? ( media-libs/openusd )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

RESTRICT="test mirror"
DOCS=( AUTHORS CONTRIBUTING.md README.md )

src_configure() {
	CMAKE_BUILD_TYPE=Release
	local mycmakeargs=(
		-DBUILD_ANIMATION_ENCODING=OFF
		-DBUILD_FOR_GLTF=$(usex gltf)
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_USD_PLUGIN=$(usex usd)
		-DEMSCRIPTEN=OFF
		-DENABLE_BACKWARDS_COMPATIBILITY=$(usex compat)
		-DENABLE_DECODER_ATTRIBUTE_DEDUPLICATION=OFF
		-DENABLE_EXTRA_SPEED=OFF
		-DENABLE_MESH_COMPRESSION=ON
		-DENABLE_POINT_CLOUD_COMPRESSION=ON
		-DENABLE_PREDICTIVE_EDGEBREAKER=ON
		-DENABLE_STANDARD_EDGEBREAKER=ON
		-DENABLE_TESTS=OFF
	)

	cmake_src_configure
}
