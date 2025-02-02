'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "dbed2ccce4bbb51ec6cb0f16d4c324ad",
"version.json": "815cdc9dd45f86cb16261d7f71e3dea4",
"index.html": "b59bc5f26c32b932b798d64504f8f0a6",
"/": "b59bc5f26c32b932b798d64504f8f0a6",
"main.dart.js": "02ebe5c61b319db7303e4c5d4819407a",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "30ddf8dbd5af0e6fa10cf127caed713b",
"assets/AssetManifest.json": "cb5960a4721c7a63c3c38455a4d89e77",
"assets/NOTICES": "bc2384d2cfd5aa1dd8b240e0bfa0259a",
"assets/FontManifest.json": "e42085be846a36f05d862eca00b47153",
"assets/AssetManifest.bin.json": "fbc8be2d5c01df62b4c6d40adc997887",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "a2eb084b706ab40c90610942d98886ec",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "4769f3245a24c1fa9965f113ea85ec2a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "2aea57c7743dcceb8bb92ba43c0a83a3",
"assets/fonts/MaterialIcons-Regular.otf": "919d8ff7369cdd66545161a852325499",
"assets/assets/images/0010050041.jpg": "bdd485711aee57a5fe915b2215380137",
"assets/assets/images/0010010471.jpg": "741d068e047992a99ccb438c57ccffe3",
"assets/assets/images/0010040291.jpg": "8491d15d6e5d959b08c4ee3080231a87",
"assets/assets/images/0010010101.jpg": "4f1daebb2b34cc0df61a6215b6a2faa9",
"assets/assets/images/0010050451.jpg": "0046b8419c85271cefe6268118f86537",
"assets/assets/images/0010010061.jpg": "dda0c758094597ccdd8ac7c0eefb62de",
"assets/assets/images/0010020161.jpg": "609878600803966dc7a36616c0847b7e",
"assets/assets/images/0010050121.jpg": "712b2ee787b150f98c33a0f314a3b126",
"assets/assets/images/0010020411.jpg": "24a67a4330a458ac8c7018f3d318773e",
"assets/assets/images/0010030171.jpg": "833f7680c33dcd40df47a9764942150a",
"assets/assets/images/0010040441.jpg": "3249925cdc9ea8e34e0820b3fa124ba9",
"assets/assets/images/0010030401.jpg": "5280d44df0c1221c3107451fcb66eac6",
"assets/assets/images/0010040131.jpg": "6800bd8512de2e050498fb2a1ee01bb5",
"assets/assets/images/0010050281.jpg": "c687bae9b9a5961641c720c052f49e07",
"assets/assets/images/0010040051.jpg": "cccb85377f16d369f214ca4411db05f4",
"assets/assets/images/0010030011.jpg": "770e36cb7cca096fcc9dd6ce555b0bfd",
"assets/assets/images/0010040251.jpg": "4099a9afc3f1462f8f3d59ef2ab97c2c",
"assets/assets/images/0010050081.jpg": "0be4ae80fa6fc6960bba5ead2892cac4",
"assets/assets/images/0010030211.jpg": "a7f29542eeb169dd41162101425db353",
"assets/assets/images/0010030371.jpg": "e4bf99be487992cb61a000d0ba55fde4",
"assets/assets/images/0010050491.jpg": "5dbc50c1d6a1c96bd622baca8540983e",
"assets/assets/images/0010040331.jpg": "c3c052d272346cb39f8538eab2f36496",
"assets/assets/images/0010040481.jpg": "c2e8f48ed15e54b4cd254c38ea41bd40",
"assets/assets/images/0010020361.jpg": "f7f40627c7a41e0752fbf71f2371bc7a",
"assets/assets/images/0010010261.jpg": "bcf4bbc9f77fedfcf5ddf664db5b56a7",
"assets/assets/images/0010050321.jpg": "e3d400397579731eae2cd6cf3964c16e",
"assets/assets/images/0010040091.jpg": "75c290ddb682d448d8321bf6deeef375",
"assets/assets/images/0010050241.jpg": "015bf9c961633e25ec372f19ab51ea7a",
"assets/assets/images/0010020201.jpg": "1f39ee6cc49ccceb078f4055164a319e",
"assets/assets/images/0010010301.jpg": "aa834a09dbaf05e26ef01138566a6c02",
"assets/assets/images/0010010311.jpg": "b60f32866bb46be8d5782547585107f1",
"assets/assets/images/0010020211.jpg": "94827efd7623858330d807e79518b416",
"assets/assets/images/0010050251.jpg": "64d081ae81478259bf400cb6cd807ed2",
"assets/assets/images/0010040081.jpg": "ed2c0a0a28ed3a02afab18df38a97836",
"assets/assets/images/0010050331.jpg": "171d7978ec96208a2bb1142ec78d6160",
"assets/assets/images/0010010271.jpg": "11b2b6069a1b084177ed846c978c4495",
"assets/assets/images/0010040491.jpg": "da97f2bf5baf16a255b51f4feda657c1",
"assets/assets/images/0010020371.jpg": "9e9c8c7221a1b742c0e20a1c474cf2a5",
"assets/assets/images/0010040321.jpg": "4b09597318eff587e8d70867b4760f23",
"assets/assets/images/0010030361.jpg": "e07bedd2fb16007924c65f385e7c1263",
"assets/assets/images/0010050481.jpg": "829124617348094db7615e832e136278",
"assets/assets/images/0010030201.jpg": "7dcc86385f70bf3a3ed4857f6d2d4872",
"assets/assets/images/0010050091.jpg": "e7913fab1d89e7292b5254d53eeb3714",
"assets/assets/images/0010040241.jpg": "813d96b2baa17690e68308f7a6b62cde",
"assets/assets/images/0010040041.jpg": "405132d3a4bbe74cb0366732133934a6",
"assets/assets/images/0010050291.jpg": "f4e2bc76e68ee8b043eeeb73ecb298c0",
"assets/assets/images/0010040121.jpg": "559a2a390e953e971fd85f53ab08b8dd",
"assets/assets/images/0010030411.jpg": "28fee5660056374c9f38afb82f6184ad",
"assets/assets/images/0010040451.jpg": "9421f08eae45b60721396c393296b707",
"assets/assets/images/0010030161.jpg": "c9ef5ac395ea03282eb1d9ba702e99fc",
"assets/assets/images/0010020401.jpg": "5267a75efd97a559580cde8575525a4a",
"assets/assets/images/0010010501.jpg": "32b456395fc6d1e3766e9214d574ed57",
"assets/assets/images/0010050131.jpg": "824c16df16c575f77fb864670d05c54d",
"assets/assets/images/0010020171.jpg": "d54694caf316b38efe80e1321b29e657",
"assets/assets/images/0010050441.jpg": "9e7ac81a3dd95fa321b98b6596753071",
"assets/assets/images/0010010071.jpg": "218ef7a05cb47661dfd702cc7e435439",
"assets/assets/images/0010020011.jpg": "bfc2bb5065d4471a715834039ed83862",
"assets/assets/images/0010010111.jpg": "27996e64775781017c12d10f5076b618",
"assets/assets/images/0010040281.jpg": "4055e0d456ab6c4e8ed8545087105c74",
"assets/assets/images/0010010461.jpg": "55a92f4614b97d90a34fe66445e42916",
"assets/assets/images/0010040231.jpg": "351c9c41eaea06f76c0a2f7570a11bd1",
"assets/assets/images/0010030271.jpg": "303d2701ad450335fa279ec83ba967a2",
"assets/assets/images/0010030311.jpg": "06daa7090373ac6ad8ad4dcdfa615aa0",
"assets/assets/images/0010040351.jpg": "cd367bf50aff91a12edb9d9b8316e53b",
"assets/assets/images/0010050181.jpg": "72378f7883ac6f7ea9e0f83412cc7d23",
"assets/assets/images/0010020301.jpg": "5ae45cb8f42bbb49ed299541f7afff7d",
"assets/assets/images/0010010201.jpg": "0347dd6990d5341d2788c7ed15650d8c",
"assets/assets/images/0010040191.jpg": "f92d2c85fb750e046ece5fbe35605623",
"assets/assets/images/0010050341.jpg": "ca0bcf960212a8722bbe913f2bcf3261",
"assets/assets/images/0010050221.jpg": "b0519a5f974fd3fadb3993c0c67198dd",
"assets/assets/images/0010020261.jpg": "7dec00bec594ef16a9a16028c85668d3",
"assets/assets/images/0010010361.jpg": "f8acf9f5f188c25f8c1f00465e52467a",
"assets/assets/images/0010010411.jpg": "dc7553788b05fba999903b89411f0f03",
"assets/assets/images/0010050021.jpg": "9e6ea759b48a223bca311e9f6851634d",
"assets/assets/images/0010010161.jpg": "005c289c435da8f9f5865ddc146bd267",
"assets/assets/images/0010020061.jpg": "a9b709af65636fb5f51f5e6391a8d655",
"assets/assets/images/0010050431.jpg": "2a85be9b7512c94a0b3303f51a1c59b9",
"assets/assets/images/0010020101.jpg": "99e344b3e38d82bad445b6f4be6110a5",
"assets/assets/images/0010050141.jpg": "8b843eaba0bb6bee7069214aa42051d6",
"assets/assets/images/0010040391.jpg": "75a6ea1c3d0b0ed8239897bbd049bc91",
"assets/assets/images/0010020471.jpg": "38b3726fee61fed54a98cc1ac478ff58",
"assets/assets/images/0010030111.jpg": "df0ade60b8c28351c61ed0dfd67642f7",
"assets/assets/images/0010040421.jpg": "51ac3841157c84329ae28370650c0280",
"assets/assets/images/0010030461.jpg": "6cc4aaeb60ed85cdf49a7fa245e2df37",
"assets/assets/images/0010050381.jpg": "f7d5f59d87f469922f90183470982744",
"assets/assets/images/0010040151.jpg": "b7ab44b105d865d3edc8ccd3843985ef",
"assets/assets/images/0010030501.jpg": "0bd5249b34d00a1d86b901f27e8f6288",
"assets/assets/images/0010040031.jpg": "efab221149d230276f89ba4147092603",
"assets/assets/images/0010030071.jpg": "951bbaeca1da36fe8ae6d5455f5b10bb",
"assets/assets/images/0010030061.jpg": "5b9cd15ef80177da050e6c9275468f6d",
"assets/assets/images/0010040021.jpg": "752d49be267922404ef2e8c013698838",
"assets/assets/images/0010040141.jpg": "07fa09a130a20afff4b43df5219d6443",
"assets/assets/images/0010030471.jpg": "f4af7548fdd66fe7c4367692116e60b3",
"assets/assets/images/0010050391.jpg": "76c800dc33bf4923791097027157d6e5",
"assets/assets/images/0010040431.jpg": "f89225690a80a4bf609bcd800d12a09e",
"assets/assets/images/0010030101.jpg": "9c0cfb9cb24ea7817509a9ca718a55a0",
"assets/assets/images/0010040381.jpg": "2347c3ba79852abbffb857741f122f3c",
"assets/assets/images/0010020461.jpg": "65b326a16674c15ce17aa24825c41771",
"assets/assets/images/0010050151.jpg": "f5221f422973baaffd5420e50b2e681d",
"assets/assets/images/0010020111.jpg": "9126e1e85249670f3617e6e56b4d6603",
"assets/assets/images/0010010011.jpg": "2de11b9211621689881e66fdce508e98",
"assets/assets/images/0010050421.jpg": "efb9613d581cc96bde3efb0020e70a92",
"assets/assets/images/0010020071.jpg": "6cc4aaeb60ed85cdf49a7fa245e2df37",
"assets/assets/images/0010010171.jpg": "7668c2f35214a341e6bfc3e8c30b5739",
"assets/assets/images/0010020501.jpg": "8e12fa51d1c3fec5291ef4a87816ec8c",
"assets/assets/images/0010010401.jpg": "75220fb9be1cd61086d9c5ed9a331d1c",
"assets/assets/images/0010050031.jpg": "45c8ce110520f0f0d8652e16065ec804",
"assets/assets/images/0010010371.jpg": "c87fe875579bdb7ba841083961a72aae",
"assets/assets/images/0010020271.jpg": "3f618e31522f2d57b741290a74b907e9",
"assets/assets/images/0010050231.jpg": "a86e733a8671e5e8416da6f42ae2a478",
"assets/assets/images/0010050351.jpg": "8abf4089281af9327dfe9a3dd9f75ca6",
"assets/assets/images/0010040181.jpg": "0550c2e4b72d50ea8083e9a440d52ec9",
"assets/assets/images/0010010211.jpg": "dc5e967cfbbff059b9fce61c29ab084c",
"assets/assets/images/0010020311.jpg": "b06fc3b740ccbbe29c0c230c463464c7",
"assets/assets/images/0010050191.jpg": "9a46824414a86e4b58f77cdc8086c5dc",
"assets/assets/images/0010040341.jpg": "76610d3d13b579b1215aa35a2ebf6502",
"assets/assets/images/0010030301.jpg": "1bd6e93a7bb7311b5e43d15795b9b36d",
"assets/assets/images/0010030261.jpg": "3dc1f0705276ddf1b43535e5e1cb1b4b",
"assets/assets/images/0010010341.jpg": "7972b850869b9d2dc240cc70a9d10731",
"assets/assets/images/0010030091.jpg": "bdcbbcd539bc96748bb02fdc30792fd8",
"assets/assets/images/0010050201.jpg": "64e1726772abbb3a8bb6346070986aa9",
"assets/assets/images/0010030481.jpg": "dead476843850eab752e1be79a9a3fd2",
"assets/assets/images/0010050361.jpg": "f468254be617736c96c6f73d1eb14600",
"assets/assets/images/0010010221.jpg": "d1b4fb21a5bc8009640940093a0ecfc1",
"assets/assets/images/0010020321.jpg": "fa25f42dbfd1620f1e860bfb55113287",
"assets/assets/images/0010040371.jpg": "ed0fb0172ebf27facc2693c2eab2e52e",
"assets/assets/images/0010020491.jpg": "5066ac9f5d1b3bdb31c4f0e489924cd1",
"assets/assets/images/0010030331.jpg": "7372913cc083be16120fbb2872db4bae",
"assets/assets/images/0010010181.jpg": "387fc1663683fc349ac7d3a60708945f",
"assets/assets/images/0010030251.jpg": "e49e655c07cea74b77ce0563f8c86217",
"assets/assets/images/0010020081.jpg": "d8f0dbe3473da3c84e0d770d5b087008",
"assets/assets/images/0010040211.jpg": "235f806f863368208e4391bfdebbeb38",
"assets/assets/images/0010020281.jpg": "a3be8ba5635e99f4fd85157044c577bf",
"assets/assets/images/0010030051.jpg": "337ac81523f48a20eda3f01bb76743c4",
"assets/assets/images/0010010381.jpg": "a18cfa8f4d401ff27e00d76f28a0a51e",
"assets/assets/images/0010040011.jpg": "938ae0479e95948d75b5f95cd505cb29",
"assets/assets/images/0010040171.jpg": "c4ca52e2243609ca62db941d14dec4c7",
"assets/assets/images/0010030441.jpg": "95bcb2049b34c0aaa401f05987cc13e1",
"assets/assets/images/0010040401.jpg": "42655a3d76e2ab2b279d1caee1c98f33",
"assets/assets/images/0010030131.jpg": "988dd4541dc4a2a85f7a82fa6e6f9632",
"assets/assets/images/0010020451.jpg": "6472454949c42699a7c8abf9ee0cbbdf",
"assets/assets/images/0010050161.jpg": "fbc332357f3b5c0e30124b36c14b4a92",
"assets/assets/images/0010020121.jpg": "b8552e300091114cd910c040e4d0d658",
"assets/assets/images/0010050411.jpg": "05a8353062ec3bcaffc40992f730ee5c",
"assets/assets/images/0010010021.jpg": "9454f3b08decaae795fbc19106297a50",
"assets/assets/images/0010020041.jpg": "cdc60e83057791948d211923917e9966",
"assets/assets/images/0010030291.jpg": "a1e48899ad59da1dcb372b620ef6c0e5",
"assets/assets/images/0010010141.jpg": "9d1e367621eff235299299ba71a8b630",
"assets/assets/images/0010010431.jpg": "f105cdd2642d21e68ee86a158496fe08",
"assets/assets/images/0010050011.jpg": "b0cb8ab36b6832f15ae2c261b7f591b8",
"assets/assets/images/0010010421.jpg": "cce3f23a61fd076e956250e4fe68211c",
"assets/assets/images/0010010151.jpg": "c44672ea254b8df1fdd13a91b0cde878",
"assets/assets/images/0010030281.jpg": "047dc14e20ca603c6a0f160810c68d0a",
"assets/assets/images/0010020051.jpg": "9e8e2bbe8dcefd473f87069c720823e5",
"assets/assets/images/0010050401.jpg": "72e67bbfad01b4ec827548b71fca27e4",
"assets/assets/images/0010010031.jpg": "9421f08eae45b60721396c393296b707",
"assets/assets/images/0010020131.jpg": "f7f40627c7a41e0752fbf71f2371bc7a",
"assets/assets/images/0010050171.jpg": "f4bea924e02fb76cba35b0dec84c64b4",
"assets/assets/images/0010020441.jpg": "fe838df64fed6780029e7d1eb0b5a28e",
"assets/assets/images/0010030121.jpg": "5bb23c520775916393f56673c57f1ab5",
"assets/assets/images/0010040411.jpg": "5205fa63b37283d91e34d24744e91b3d",
"assets/assets/images/0010030451.jpg": "f11e89c42a5f257b549c5e469ad81cc2",
"assets/assets/images/0010040161.jpg": "4d333a657d0394572237645b34a8fad6",
"assets/assets/images/0010010391.jpg": "5a33a43f2bc30589dda9a95dd8e61616",
"assets/assets/images/0010030041.jpg": "adeb7c53551142dec29f7fab40a723a8",
"assets/assets/images/0010020291.jpg": "b941610506286afdbb2610d4ea5d8fd4",
"assets/assets/images/0010040201.jpg": "2c31d10532ec5fdbc1ce6cce66a10800",
"assets/assets/images/0010020091.jpg": "5080466afb945fe0ba06a0bc4e8c9d66",
"assets/assets/images/0010030241.jpg": "f30800ec80ba3c5fda0b9d723a06eb19",
"assets/assets/images/0010010191.jpg": "2d8c0a3de8179a7f4460c34563b27f3f",
"assets/assets/images/0010030321.jpg": "0a1d1eb702f652956d54a36908d635d1",
"assets/assets/images/0010040361.jpg": "1ed252d3d211aacff2e8abdde8605d7a",
"assets/assets/images/0010020481.jpg": "e2356db0e841a0405a27cc8a467abf69",
"assets/assets/images/0010020331.jpg": "5b94d8a1e0435b349e99a2e6f5cd87c4",
"assets/assets/images/0010010231.jpg": "7dab270cd0fbc9ceb59c8e4ff95a3445",
"assets/assets/images/0010030491.jpg": "f6553b4de6f48c93c1e0cd0c3278d8b1",
"assets/assets/images/0010050371.jpg": "c8dbe8c57e8ece6e1769564c7201797c",
"assets/assets/images/0010050211.jpg": "2d236f290c226772ff6278d1ef179537",
"assets/assets/images/0010030081.jpg": "3618249cbcb9cd69f3928c09bfbc00b8",
"assets/assets/images/0010010351.jpg": "70df9b738908b1bb0c5a3d70b377f898",
"assets/assets/images/0010040501.jpg": "a363d83fb17c0732d2484317e4c2a9bd",
"assets/assets/images/0010030031.jpg": "5dfac4801078875376888c5cdec7f2e0",
"assets/assets/images/0010040071.jpg": "4c7f33a437d8e49d70ceceaf29d96992",
"assets/assets/images/0010040111.jpg": "ffb5b89f630ca7fa4194208b6e3943d0",
"assets/assets/images/0010030421.jpg": "d14fa41955fc7a31582f1cb443d8c4bc",
"assets/assets/images/0010040461.jpg": "9f974c3cd4124d03ba2084b4b41391cb",
"assets/assets/images/0010020381.jpg": "6a7990929162bc172fda6bdb4d21d0b2",
"assets/assets/images/0010030151.jpg": "3e491dd7c52d3d04327f6d9f69d53e64",
"assets/assets/images/0010010281.jpg": "a934f6960265bbb74c63af2d9dc8005d",
"assets/assets/images/0010020431.jpg": "5304e9430053d8038cc8128ca4ec903a",
"assets/assets/images/0010050101.jpg": "0cffe8443452cc30c1f4774d39f14d49",
"assets/assets/images/0010020141.jpg": "53ea6fdfe36d30ce9e0b3151496a6dc0",
"assets/assets/images/0010030391.jpg": "0046b8419c85271cefe6268118f86537",
"assets/assets/images/0010010041.jpg": "11028dba3585a4cc87fb381c1542c86e",
"assets/assets/images/0010050471.jpg": "9066b6ce2fd0e543468442f9642d2ae6",
"assets/assets/images/0010020021.jpg": "5461a78f33f78dfc7f71c6a344e8b819",
"assets/assets/images/0010010121.jpg": "ad6959c2c4a685ffd2eba7523b98e0c0",
"assets/assets/images/0010010451.jpg": "a9c91d7a140c38ebbfea97be5f3ae703",
"assets/assets/images/0010050061.jpg": "7f18a8ad93214db88c90e541d7535fb8",
"assets/assets/images/010030261.jpg": "6566d6dbcc4cadb65030fc8449e6d93c",
"assets/assets/images/0010010321.jpg": "0940c0a48501edb250b2f113aa705aaa",
"assets/assets/images/0010050261.jpg": "d7f6611726dc6fe3aabf4e38a37a61e0",
"assets/assets/images/0010050301.jpg": "5c1970334a83f365503c43870ec1019c",
"assets/assets/images/0010010241.jpg": "d30d1a1d6ef6ee34ab1d86a2a901766d",
"assets/assets/images/0010030191.jpg": "fdeb6860640dbd1988c77f2e267d8870",
"assets/assets/images/0010020341.jpg": "7ef9fc294c2d3130da8cbfc384b1b259",
"assets/assets/images/0010040311.jpg": "813d96b2baa17690e68308f7a6b62cde",
"assets/assets/images/0010010081.jpg": "f0c4f0de2cf1478852f0f5c8eae34d17",
"assets/assets/images/0010030351.jpg": "c5c75fac76ee612cabd84f9704f826f4",
"assets/assets/images/0010020181.jpg": "7a5c58533bb95cac9deb8afa87cd2d89",
"assets/assets/images/0010030231.jpg": "aff2250b9ceca0fb10a818eef5a58ccd",
"assets/assets/images/0010010491.jpg": "1f4cb8a0fcf3915bc0082d0f849ce944",
"assets/assets/images/0010040271.jpg": "1ed252d3d211aacff2e8abdde8605d7a",
"assets/assets/images/0010040261.jpg": "2f31f2606a43ac18c3621d587fda3d22",
"assets/assets/images/0010010481.jpg": "6fde898e925c453987b58597f582008e",
"assets/assets/images/0010020191.jpg": "116ea356fc1a3689b8ba0b6f6b84bc0f",
"assets/assets/images/0010030341.jpg": "864f27530fea8dadcd54a74c2a612a3b",
"assets/assets/images/0010010091.jpg": "2e87f41ad43e89bc5c05980826e97b23",
"assets/assets/images/0010040301.jpg": "4f6372a6ec29e67e4ac689e10ea90916",
"assets/assets/images/0010020351.jpg": "d6f3ad32dbf9da1d5eda0e72e36928cf",
"assets/assets/images/0010030181.jpg": "ee02e21ae6463d4e51dd87412c5cecb1",
"assets/assets/images/0010010251.jpg": "8f84df0dec3d3b51536e52b1bd4caf18",
"assets/assets/images/0010050311.jpg": "26c35b7a7c3a9a08f920bb6386bdb77f",
"assets/assets/images/0010050271.jpg": "937d1ff72a93ca12c5ba79ca15f7a80c",
"assets/assets/images/0010020231.jpg": "b0519a5f974fd3fadb3993c0c67198dd",
"assets/assets/images/0010010331.jpg": "1b0a07403a3e71324625d461f93f7c1b",
"assets/assets/images/0010010441.jpg": "7dd7d8c80fc6cc30258e4da08445cb8b",
"assets/assets/images/0010050071.jpg": "cb414b31479736c39765811b150e8679",
"assets/assets/images/0010010131.jpg": "15d707a70036f62be6c0dd998c40248f",
"assets/assets/images/0010020031.jpg": "befab9229858490348403e69ef68f945",
"assets/assets/images/0010010051.jpg": "d9ba224faa5a13d7b1d045cb732b0d1e",
"assets/assets/images/0010030381.jpg": "1f86ee4fb4fd32b36c8fdfcbade57da1",
"assets/assets/images/0010050461.jpg": "1d4a4358e0c5e57bc3f5f05cef8d3526",
"assets/assets/images/0010020151.jpg": "af6c1dc658486bcbaabc9f99aa695e42",
"assets/assets/images/0010050111.jpg": "4a14cb98fa90b21fe9ee575f060d2f49",
"assets/assets/images/0010060011.jpg": "d86ae7ee824d5e98475d1e56cf7cbb10",
"assets/assets/images/0010020421.jpg": "49b200e959adfa1017ffff6499afda07",
"assets/assets/images/0010010291.jpg": "4b818cdc98550fd09abadf8179ce57e5",
"assets/assets/images/0010030141.jpg": "0c4d6a2f150327825b584364b0105bbc",
"assets/assets/images/0010040471.jpg": "5851219a74964267c4393487f76e473b",
"assets/assets/images/0010020391.jpg": "69f66b9f62a0af6fcd6731dd0fb32f7c",
"assets/assets/images/0010030431.jpg": "8fa9b9e5d899c415543111b0c4c7ad4b",
"assets/assets/images/0010040101.jpg": "0ea1cbecbe85698a2fa821d2d0db2da1",
"assets/assets/images/0010040061.jpg": "6102d10dfaa58539bcf6c7178bd53470",
"assets/assets/images/0010030021.jpg": "c35f21817ada114713fbd6ba0de52136",
"assets/assets/AssetManifest.json": "2efbb41d7877d10aac9d091f58ccd7b9",
"assets/assets/NOTICES": "938842f1aeb30f4cebef96dba77a5e5a",
"assets/assets/json/words_v2.json": "b71ac693b02d92af47f359326d67961f",
"assets/assets/json/words_v3.json": "eb7576ddbe3cff7f6a574d23e6676b51",
"assets/assets/json/words_test.json": "969706e6e2349ec53ffdb9e958994505",
"assets/assets/json/words_1_1_0.json": "dfdaf85b7985c09f008ff045e3c7ca52",
"assets/assets/json/words_zz.json": "4ad0646fe32e28f4603a2c5723f0b387",
"assets/assets/json/words.json": "8044851d6fcf189e50c502e5f0b6db03",
"assets/assets/json/words_v1.json": "fb911317f0305f82c0d3f81be1fec6dd",
"assets/assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/AssetManifest.bin.json": "69a99f98c8b1fb8111c5fb961769fcd8",
"assets/assets/icons/formal.png": "1601c3788c6e51088151e41b99a0eeb8",
"assets/assets/icons/audioLogoWhite.png": "aeb87cff8917d7151f14c10502faccad",
"assets/assets/icons/casual.png": "c70c30a2bef1a6bf98ba226b50fa4628",
"assets/assets/icons/error.png": "15a9990a2c873335e0e394642027b474",
"assets/assets/icons/business.png": "a1951f9c984f31fd99eff468bbdf3a81",
"assets/assets/icons/slung.png": "b8df56f09b5a5773f874cac1a39a03a1",
"assets/assets/AssetManifest.bin": "693635b5258fe5f1cda720cf224f158c",
"assets/assets/fonts/Urbanist-Bold.ttf": "1ffe51e22e7841c65481a727515e2198",
"assets/assets/fonts/NotoSansJP-Bold.ttf": "4aec04fd98881db5fbc79075428727ef",
"assets/assets/fonts/Urbanist-SemiBold.ttf": "ae731014b8aa4267df78b8e854d006ef",
"assets/assets/fonts/NotoSansJP-Regular.ttf": "022f32abf24d5534496095e04aa739b3",
"assets/assets/fonts/NotoSansJP-SemiBold.ttf": "2f9b41d9040065bcce6ad91656732829",
"assets/assets/fonts/Urbanist-ExtraBold.ttf": "f4a05764495d2286312d1c6edd9513b4",
"assets/assets/fonts/MaterialIcons-Regular.otf": "8ea08ea2444cc58ec5807fd7669e488f",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
