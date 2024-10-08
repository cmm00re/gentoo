# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ECM_HANDBOOK="forceoff"
ECM_TEST="optional"
KDE_ORG_CATEGORY="network"
KFMIN=5.106.0
QTMIN=5.15.9
inherit ecm gear.kde.org

DESCRIPTION="KIO worker for Google Drive service"
HOMEPAGE="https://apps.kde.org/kio_gdrive/"

LICENSE="GPL-2+"
SLOT="5"
KEYWORDS="~amd64 ~arm64"
IUSE="kf6compat +share"

COMMON_DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	|| (
		kde-apps/kaccounts-integration:6[qt5]
		>=kde-apps/kaccounts-integration-23.08:5
	)
	kde-apps/libkgapi:5
	>=kde-frameworks/kcoreaddons-${KFMIN}:5
	>=kde-frameworks/ki18n-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
	>=kde-frameworks/knotifications-${KFMIN}:5
	share? ( >=kde-frameworks/purpose-${KFMIN}:5 )
"
DEPEND="${COMMON_DEPEND}
	>=dev-qt/qtnetwork-${QTMIN}:5
"
RDEPEND="${COMMON_DEPEND}
	kde-apps/kaccounts-providers:*
	${CATEGORY}/${PN}-common
"
BDEPEND="dev-util/intltool"

DOCS=( README.md )

ECM_REMOVE_FROM_INSTALL=(
	/usr/share/accounts/services/kde/google-drive.service
	/usr/share/metainfo/org.kde.kio_gdrive.metainfo.xml
	/usr/share/remoteview/gdrive-network.desktop
)

src_prepare() {
	if has_version -b "kde-apps/kaccounts-integration:6[qt5]"; then
		PATCHES+=( "${FILESDIR}/${P}-kaccounts-integration-24.02.patch" )
	fi
	ecm_src_prepare
	ecm_punt_po_install
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package share KF5Purpose)
	)
	ecm_src_configure
}

src_install() {
	ecm_src_install

	if use kf6compat && use share; then
		rm -r "${D}"/usr/share/purpose/purpose_gdrive_config.qml || die
	fi
}
