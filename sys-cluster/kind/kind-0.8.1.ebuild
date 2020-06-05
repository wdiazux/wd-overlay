# Copyright 2020 William Diaz <william@wdiaz.org>
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module bash-completion-r1
GIT_COMMIT=1170b6b2e2bded824a246bb85b128ceb22e69511

DESCRIPTION="Run local Kubernetes cluster in Docker"
HOMEPAGE="https://kind.sigs.k8s.io/"

EGO_SUM=(
		"cloud.google.com/go v0.26.0/go.mod"
		"github.com/BurntSushi/toml v0.3.1"
		"github.com/BurntSushi/toml v0.3.1/go.mod"
		"github.com/NYTimes/gziphandler v0.0.0-20170623195520-56545f4a5d46/go.mod"
		"github.com/OneOfOne/xxhash v1.2.2/go.mod"
		"github.com/PuerkitoBio/purell v1.0.0/go.mod"
		"github.com/PuerkitoBio/urlesc v0.0.0-20160726150825-5bd2802263f2/go.mod"
		"github.com/alecthomas/template v0.0.0-20160405071501-a0175ee3bccc/go.mod"
		"github.com/alecthomas/units v0.0.0-20151022065526-2efee857e7cf/go.mod"
		"github.com/alessio/shellescape v1.2.2"
		"github.com/alessio/shellescape v1.2.2/go.mod"
		"github.com/armon/consul-api v0.0.0-20180202201655-eb2c6b5be1b6/go.mod"
		"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod"
		"github.com/beorn7/perks v1.0.0/go.mod"
		"github.com/cespare/xxhash v1.1.0/go.mod"
		"github.com/client9/misspell v0.3.4/go.mod"
		"github.com/coreos/bbolt v1.3.2/go.mod"
		"github.com/coreos/etcd v3.3.10+incompatible/go.mod"
		"github.com/coreos/go-semver v0.2.0"
		"github.com/coreos/go-semver v0.2.0/go.mod"
		"github.com/coreos/go-systemd v0.0.0-20190321100706-95778dfbb74e/go.mod"
		"github.com/coreos/pkg v0.0.0-20180928190104-399ea9e2e55f/go.mod"
		"github.com/cpuguy83/go-md2man/v2 v2.0.0/go.mod"
		"github.com/davecgh/go-spew v1.1.0/go.mod"
		"github.com/davecgh/go-spew v1.1.1"
		"github.com/davecgh/go-spew v1.1.1/go.mod"
		"github.com/dgrijalva/jwt-go v3.2.0+incompatible/go.mod"
		"github.com/dgryski/go-sip13 v0.0.0-20181026042036-e10d5fee7954/go.mod"
		"github.com/docker/spdystream v0.0.0-20160310174837-449fdfce4d96/go.mod"
		"github.com/elazarl/goproxy v0.0.0-20180725130230-947c36da3153/go.mod"
		"github.com/emicklei/go-restful v0.0.0-20170410110728-ff4f55a20633/go.mod"
		"github.com/evanphx/json-patch v4.2.0+incompatible"
		"github.com/evanphx/json-patch v4.2.0+incompatible/go.mod"
		"github.com/evanphx/json-patch/v5 v5.0.0"
		"github.com/evanphx/json-patch/v5 v5.0.0/go.mod"
		"github.com/fsnotify/fsnotify v1.4.7/go.mod"
		"github.com/ghodss/yaml v0.0.0-20150909031657-73d445a93680/go.mod"
		"github.com/ghodss/yaml v1.0.0/go.mod"
		"github.com/go-kit/kit v0.8.0/go.mod"
		"github.com/go-logfmt/logfmt v0.3.0/go.mod"
		"github.com/go-logfmt/logfmt v0.4.0/go.mod"
		"github.com/go-logr/logr v0.1.0/go.mod"
		"github.com/go-openapi/jsonpointer v0.0.0-20160704185906-46af16f9f7b1/go.mod"
		"github.com/go-openapi/jsonreference v0.0.0-20160704190145-13c6e3589ad9/go.mod"
		"github.com/go-openapi/spec v0.0.0-20160808142527-6aced65f8501/go.mod"
		"github.com/go-openapi/swag v0.0.0-20160704191624-1d0bd113de87/go.mod"
		"github.com/go-stack/stack v1.8.0/go.mod"
		"github.com/gogo/protobuf v1.1.1/go.mod"
		"github.com/gogo/protobuf v1.2.1/go.mod"
		"github.com/gogo/protobuf v1.3.1/go.mod"
		"github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b/go.mod"
		"github.com/golang/groupcache v0.0.0-20160516000752-02826c3e7903/go.mod"
		"github.com/golang/groupcache v0.0.0-20190129154638-5b532d6fd5ef/go.mod"
		"github.com/golang/mock v1.1.1/go.mod"
		"github.com/golang/protobuf v0.0.0-20161109072736-4bd1920723d7/go.mod"
		"github.com/golang/protobuf v1.2.0/go.mod"
		"github.com/golang/protobuf v1.3.1/go.mod"
		"github.com/golang/protobuf v1.3.2/go.mod"
		"github.com/google/btree v1.0.0/go.mod"
		"github.com/google/go-cmp v0.2.0/go.mod"
		"github.com/google/go-cmp v0.3.0/go.mod"
		"github.com/google/gofuzz v1.0.0/go.mod"
		"github.com/google/gofuzz v1.1.0/go.mod"
		"github.com/google/uuid v1.1.1"
		"github.com/google/uuid v1.1.1/go.mod"
		"github.com/googleapis/gnostic v0.0.0-20170729233727-0c5108395e2d/go.mod"
		"github.com/googleapis/gnostic v0.1.0/go.mod"
		"github.com/gorilla/websocket v1.4.0/go.mod"
		"github.com/grpc-ecosystem/go-grpc-middleware v1.0.0/go.mod"
		"github.com/grpc-ecosystem/go-grpc-prometheus v1.2.0/go.mod"
		"github.com/grpc-ecosystem/grpc-gateway v1.9.0/go.mod"
		"github.com/hashicorp/golang-lru v0.5.1/go.mod"
		"github.com/hashicorp/hcl v1.0.0/go.mod"
		"github.com/hpcloud/tail v1.0.0/go.mod"
		"github.com/inconshreveable/mousetrap v1.0.0"
		"github.com/inconshreveable/mousetrap v1.0.0/go.mod"
		"github.com/jessevdk/go-flags v1.4.0/go.mod"
		"github.com/jonboulle/clockwork v0.1.0/go.mod"
		"github.com/json-iterator/go v1.1.6/go.mod"
		"github.com/json-iterator/go v1.1.8/go.mod"
		"github.com/julienschmidt/httprouter v1.2.0/go.mod"
		"github.com/kisielk/errcheck v1.1.0/go.mod"
		"github.com/kisielk/errcheck v1.2.0/go.mod"
		"github.com/kisielk/gotool v1.0.0/go.mod"
		"github.com/konsorten/go-windows-terminal-sequences v1.0.1/go.mod"
		"github.com/kr/logfmt v0.0.0-20140226030751-b84e30acd515/go.mod"
		"github.com/kr/pretty v0.1.0"
		"github.com/kr/pretty v0.1.0/go.mod"
		"github.com/kr/pty v1.1.1/go.mod"
		"github.com/kr/text v0.1.0"
		"github.com/kr/text v0.1.0/go.mod"
		"github.com/magiconair/properties v1.8.0/go.mod"
		"github.com/mailru/easyjson v0.0.0-20160728113105-d5b7844b561a/go.mod"
		"github.com/mattn/go-isatty v0.0.12"
		"github.com/mattn/go-isatty v0.0.12/go.mod"
		"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod"
		"github.com/mitchellh/go-homedir v1.1.0/go.mod"
		"github.com/mitchellh/mapstructure v1.1.2/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
		"github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd/go.mod"
		"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742/go.mod"
		"github.com/modern-go/reflect2 v1.0.1/go.mod"
		"github.com/munnerz/goautoneg v0.0.0-20120707110453-a547fc61f48d/go.mod"
		"github.com/mwitkow/go-conntrack v0.0.0-20161129095857-cc309e4a2223/go.mod"
		"github.com/mxk/go-flowrate v0.0.0-20140419014527-cca7078d478f/go.mod"
		"github.com/oklog/ulid v1.3.1/go.mod"
		"github.com/onsi/ginkgo v0.0.0-20170829012221-11459a886d9c/go.mod"
		"github.com/onsi/ginkgo v1.6.0/go.mod"
		"github.com/onsi/ginkgo v1.11.0/go.mod"
		"github.com/onsi/gomega v0.0.0-20170829124025-dcabb60a477c/go.mod"
		"github.com/onsi/gomega v1.7.0/go.mod"
		"github.com/pelletier/go-toml v1.2.0"
		"github.com/pelletier/go-toml v1.2.0/go.mod"
		"github.com/pelletier/go-toml v1.7.0"
		"github.com/pelletier/go-toml v1.7.0/go.mod"
		"github.com/pkg/errors v0.8.0/go.mod"
		"github.com/pkg/errors v0.8.1/go.mod"
		"github.com/pkg/errors v0.9.1"
		"github.com/pkg/errors v0.9.1/go.mod"
		"github.com/pmezard/go-difflib v1.0.0/go.mod"
		"github.com/prometheus/client_golang v0.9.1/go.mod"
		"github.com/prometheus/client_golang v0.9.3/go.mod"
		"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod"
		"github.com/prometheus/client_model v0.0.0-20190129233127-fd36f4220a90/go.mod"
		"github.com/prometheus/common v0.0.0-20181113130724-41aa239b4cce/go.mod"
		"github.com/prometheus/common v0.4.0/go.mod"
		"github.com/prometheus/procfs v0.0.0-20181005140218-185b4288413d/go.mod"
		"github.com/prometheus/procfs v0.0.0-20190507164030-5867b95ac084/go.mod"
		"github.com/prometheus/tsdb v0.7.1/go.mod"
		"github.com/rogpeppe/fastuuid v0.0.0-20150106093220-6724a57986af/go.mod"
		"github.com/russross/blackfriday/v2 v2.0.1/go.mod"
		"github.com/shurcooL/sanitized_anchor_name v1.0.0/go.mod"
		"github.com/sirupsen/logrus v1.2.0/go.mod"
		"github.com/soheilhy/cmux v0.1.4/go.mod"
		"github.com/spaolacci/murmur3 v0.0.0-20180118202830-f09979ecbc72/go.mod"
		"github.com/spf13/afero v1.1.2/go.mod"
		"github.com/spf13/cast v1.3.0/go.mod"
		"github.com/spf13/cobra v1.0.0"
		"github.com/spf13/cobra v1.0.0/go.mod"
		"github.com/spf13/jwalterweatherman v1.0.0/go.mod"
		"github.com/spf13/pflag v0.0.0-20170130214245-9ff6c6923cff/go.mod"
		"github.com/spf13/pflag v1.0.3/go.mod"
		"github.com/spf13/pflag v1.0.5"
		"github.com/spf13/pflag v1.0.5/go.mod"
		"github.com/spf13/viper v1.4.0/go.mod"
		"github.com/stretchr/objx v0.1.0/go.mod"
		"github.com/stretchr/objx v0.1.1/go.mod"
		"github.com/stretchr/testify v1.2.2/go.mod"
		"github.com/stretchr/testify v1.3.0/go.mod"
		"github.com/stretchr/testify v1.4.0/go.mod"
		"github.com/tmc/grpc-websocket-proxy v0.0.0-20190109142713-0ad062ec5ee5/go.mod"
		"github.com/ugorji/go v1.1.4/go.mod"
		"github.com/xiang90/probing v0.0.0-20190116061207-43a291ad63a2/go.mod"
		"github.com/xordataexchange/crypt v0.0.3-0.20170626215501-b2862e3d0a77/go.mod"
		"go.etcd.io/bbolt v1.3.2/go.mod"
		"go.uber.org/atomic v1.4.0/go.mod"
		"go.uber.org/multierr v1.1.0/go.mod"
		"go.uber.org/zap v1.10.0/go.mod"
		"golang.org/x/crypto v0.0.0-20180904163835-0709b304e793/go.mod"
		"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
		"golang.org/x/lint v0.0.0-20181026193005-c67002cb31c3/go.mod"
		"golang.org/x/lint v0.0.0-20190313153728-d0100b6bd8b3/go.mod"
		"golang.org/x/net v0.0.0-20170114055629-f2499483f923/go.mod"
		"golang.org/x/net v0.0.0-20180826012351-8a410e7b638d/go.mod"
		"golang.org/x/net v0.0.0-20180906233101-161cd47e91fd/go.mod"
		"golang.org/x/net v0.0.0-20181114220301-adae6a3d119a/go.mod"
		"golang.org/x/net v0.0.0-20181220203305-927f97764cc3/go.mod"
		"golang.org/x/net v0.0.0-20190311183353-d8887717615a/go.mod"
		"golang.org/x/net v0.0.0-20190522155817-f3200d17e092/go.mod"
		"golang.org/x/net v0.0.0-20191004110552-13f9640d40b9/go.mod"
		"golang.org/x/oauth2 v0.0.0-20180821212333-d2e6202438be/go.mod"
		"golang.org/x/sync v0.0.0-20180314180146-1d60e4601c6f/go.mod"
		"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod"
		"golang.org/x/sync v0.0.0-20181221193216-37e7f081c4d4/go.mod"
		"golang.org/x/sys v0.0.0-20170830134202-bb24a47a89ea/go.mod"
		"golang.org/x/sys v0.0.0-20180830151530-49385e6e1522/go.mod"
		"golang.org/x/sys v0.0.0-20180905080454-ebe1bf3edb33/go.mod"
		"golang.org/x/sys v0.0.0-20180909124046-d0be0721c37e/go.mod"
		"golang.org/x/sys v0.0.0-20181107165924-66b7b1311ac8/go.mod"
		"golang.org/x/sys v0.0.0-20181116152217-5ac8a444bdc5/go.mod"
		"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
		"golang.org/x/sys v0.0.0-20191022100944-742c48ecaeb7/go.mod"
		"golang.org/x/sys v0.0.0-20200116001909-b77594299b42"
		"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
		"golang.org/x/text v0.0.0-20160726164857-2910a502d2bf/go.mod"
		"golang.org/x/text v0.3.0/go.mod"
		"golang.org/x/text v0.3.2/go.mod"
		"golang.org/x/time v0.0.0-20190308202827-9d24e82272b4/go.mod"
		"golang.org/x/tools v0.0.0-20180221164845-07fd8470d635/go.mod"
		"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
		"golang.org/x/tools v0.0.0-20181011042414-1f849cf54d09/go.mod"
		"golang.org/x/tools v0.0.0-20181030221726-6c7e314b6563/go.mod"
		"golang.org/x/tools v0.0.0-20190114222345-bf090417da8b/go.mod"
		"golang.org/x/tools v0.0.0-20190311212946-11955173bddd/go.mod"
		"google.golang.org/appengine v1.1.0/go.mod"
		"google.golang.org/genproto v0.0.0-20180817151627-c66870c02cf8/go.mod"
		"google.golang.org/grpc v1.19.0/go.mod"
		"google.golang.org/grpc v1.21.0/go.mod"
		"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
		"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127"
		"gopkg.in/check.v1 v1.0.0-20180628173108-788fd7840127/go.mod"
		"gopkg.in/fsnotify.v1 v1.4.7/go.mod"
		"gopkg.in/inf.v0 v0.9.1/go.mod"
		"gopkg.in/resty.v1 v1.12.0/go.mod"
		"gopkg.in/tomb.v1 v1.0.0-20141024135613-dd632973f1e7/go.mod"
		"gopkg.in/yaml.v2 v2.0.0-20170812160011-eb3733d160e7/go.mod"
		"gopkg.in/yaml.v2 v2.2.1/go.mod"
		"gopkg.in/yaml.v2 v2.2.2/go.mod"
		"gopkg.in/yaml.v2 v2.2.8"
		"gopkg.in/yaml.v2 v2.2.8/go.mod"
		"gopkg.in/yaml.v3 v3.0.0-20200121175148-a6ecf24a6d71"
		"gopkg.in/yaml.v3 v3.0.0-20200121175148-a6ecf24a6d71/go.mod"
		"honnef.co/go/tools v0.0.0-20190102054323-c2f93a96b099/go.mod"
		"k8s.io/apimachinery v0.18.2"
		"k8s.io/apimachinery v0.18.2/go.mod"
		"k8s.io/gengo v0.0.0-20190128074634-0689ccc1d7d6/go.mod"
		"k8s.io/klog v0.0.0-20181102134211-b9b56d5dfc92/go.mod"
		"k8s.io/klog v1.0.0/go.mod"
		"k8s.io/kube-openapi v0.0.0-20200121204235-bf4fb3bd569c/go.mod"
		"sigs.k8s.io/structured-merge-diff/v3 v3.0.0-20200116222232-67a7b8c61874/go.mod"
		"sigs.k8s.io/structured-merge-diff/v3 v3.0.0/go.mod"
		"sigs.k8s.io/yaml v1.1.0"
		"sigs.k8s.io/yaml v1.1.0/go.mod"
		"sigs.k8s.io/yaml v1.2.0"
		"sigs.k8s.io/yaml v1.2.0/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/kubernetes-sigs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		${EGO_SUM_SRC_URI}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/go-1.13"
RDEPEND="app-emulation/docker"

RESTRICT="test"

PATCHES="${FILESDIR}/${PN}-local-build.patch"

src_compile() {
	emake \
		COMMIT=${GIT_COMMIT:0:7} \
		build

	bin/${PN} completion bash > ${PN}.bash || die
	bin/${PN} completion zsh > ${PN}.zsh || die
}

src_install() {
	newbashcomp ${PN}.bash ${PN}
	insinto /usr/share/zsh/site-functions
	newins ${PN}.zsh _${PN}

	dobin bin/${PN}
}
