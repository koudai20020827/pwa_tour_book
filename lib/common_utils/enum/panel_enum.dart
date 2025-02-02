import 'package:flutter/material.dart';

// 改行コード
const String LINE_FEED = '\n';

// 品詞の定義
const String NOUN = '- 名詞 (Noun)';
const String VERB = '- 動詞 (Verb)';
const String AUXILIARY_VERB = '- 助動詞 (Auxiliary Verb)';
const String ADJECTIVE = '- 形容詞 (Adjective)';
const String ADVERB = '- 副詞 (Adverb)';
const String PREPOSITION = '- 前置詞 (Preposition)';
const String CONJUNCTION = '- 接続詞 (Conjunction)';
const String PRONOUN = '- 代名詞 (Pronoun)';
const String DETERMINER = '- 限定詞 (Determiner)';
const String INTERJECTION = '- 感嘆詞 (Interjection)';
const String PARTICLE = '- 助詞 (Particle)';
const String ARTICLE = '- 冠詞 (Article)';
const String PHRASE = '- 句 (Phrase)';

const String NOUN_DETAIL = '名詞は「モノの名前」。人、場所、物、アイデアなんかを指す言葉。';
const String VERB_DETAIL =
    '動詞は「動き」や「状態」を表す言葉。「走る」とか「食べる」、「いる」みたいに、何かをしていることや、どんな状態かを表す。';
const String AUXILIARY_VERB_DETAIL =
    '助動詞は、動詞に「ちょっと意味を足す」言葉です。たとえば、「can」は「できる」、「will」は「するつもり」、「must」は「しなきゃ」の意味を足す。';
const String ADJECTIVE_DETAIL =
    '形容詞は名詞を「説明する」言葉。「かわいい猫」とか「大きな家」など、名詞がどういうものかを詳しくする役割がある。';
const String ADVERB_DETAIL =
    '副詞は（動詞、形容詞、他の副詞）を「詳しくする」言葉。例えば「早く走る」や「とてもかわいい猫」の「早く」と「とても」が副詞。動きや状態、他の説明をもっと詳しくしてくれる。';
const String PRONOUN_DETAIL =
    '代名詞は「名詞の代わり」になる言葉。「彼」とか「それ」みたいに、何度も同じ名詞を使うのを避けるために使う。「ジョンは走る。彼は速い。」みたいな感じ。';
const String PREPOSITION_DETAIL =
    '前置詞は名詞や代名詞と他の言葉の「関係」を表す言葉。「机の上にある本」みたいに、「上」とか「下」とか「中」とかで、どこに何があるかを教えてくれる。';
const String CONJUNCTION_DETAIL =
    '接続詞は「言葉や文をつなぐ」言葉。「そして」「だけど」「または」とかで、文同士をくっつけたり、選択肢をつなげたりする役割がある。';
const String ARTICLE_DETAIL =
    '冠詞は「名詞の前につける」言葉。「a」「an」「the」など。「猫」って言うときに「a cat」みたいに使うことで、その猫がどんな猫かをちょっと特定したりする。';
const String INTERJECTION_DETAIL =
    '感嘆詞は「感情や驚きを表す」言葉。「おー！」「わあ！」など、文中で感情を直接表現するために用いられる。';
const String PHRASE_DETAIL =
    'フレーズは、単語が集まって「1つの意味」を持つ言葉のまとまりです。完全な文にはならないけど、文の一部として使われる。';

// レベルの定義
const String LV1 = 'LV1 - 基礎レベル1';
const String LV2 = 'LV2 - 基礎レベル2';
const String LV3 = 'LV3 - 日常英会話レベル1';
const String LV4 = 'LV4 - 日常英会話レベル2';
const String LV5 = 'LV5 - 海外旅行レベル';
const String LV6 = 'LV6 - 海外留学レベル';
const String LV7 = 'LV7 - 海外生活レベル';
const String LV8 = 'LV8 - ビジネスレベル';
const String LV9 = 'LV9 - ビジネスレベル上級';
const String LV10 = 'LV10 - ビジネスネイティブ';

const String LV1_DETAIL = '簡単な挨拶と自己紹介ができる。単純なフレーズを使い、意思疎通できる。(TOEIC 200~300)';
const String LV2_DETAIL =
    '日常的な表現であれば、ゆっくりと話せば理解できる。基本的な質問や答えができる。(TOEIC 300~400)';
const String LV3_DETAIL =
    '基本的な日常会話ができるが、複雑な表現や言い回しには苦労する。簡単な意見交換が可能。(TOEIC 400~500)';
const String LV4_DETAIL =
    '日常生活でのやりとりはほぼ問題なくできるが、専門的な話題や抽象的な話題ではつまずくことがある。(TOEIC 500~600)';
const String LV5_DETAIL =
    '海外旅行で十分コミュニケーションを取れる。多くの状況で自信を持って話せる。仕事や学業に関連する話題にも対応可能。(TOEIC 600~650)';
const String LV6_DETAIL =
    '海外留学でネイティブスピーカーと意思疎通ができる。ほぼどんな状況でもスムーズに話せる。専門的な話題や抽象的な概念も理解し、表現できる。(TOEIC 650~700)';
const String LV7_DETAIL =
    '海外生活で生きていくことが可能なレベル。複雑な話題や抽象的な概念にも対応できる。コロケーションも十分に習得している。(TOEIC 700~750)';
const String LV8_DETAIL =
    'ビジネスパーソンとして海外で会話できる。文化的なニュアンス、ユーモアも理解し、適切に反応できる。(TOEIC 750~800)';
const String LV9_DETAIL =
    'ビジネスパーソンとして海外で交渉できる。専門知識を必要とする話題やディスカッションにも対応でき、会話の中で意図や感情を的確に伝えられる。(TOEIC 800~)';
const String LV10_DETAIL =
    'ビジネスパーソンとして海外の即戦力になれる。脳内のイメージをそのまま表現し、思うがままに英語を操れる。(TOEIC 800~)';

// 頻度の定義
const String NEVER = '- never';
const String RARELY = '- rarely';
const String SOMETIMES = '- sometimes';
const String OFTEN = '- often';
const String ALWAYS = '- always';

const String NEVER_DETAIL =
    'ほとんど使わない、特定の状況や意図がなければ使用しない表現。使用することが非常にまれで、他の表現を優先することが多い。';
const String RARELY_DETAIL =
    'めったに使わない、特定のシーンや条件が揃わない限り使用しない表現。通常は別の表現が適切である場合が多い。';
const String SOMETIMES_DETAIL =
    '時々使う、特定の状況や会話の流れによっては使用するが、頻繁には使わない表現。状況に応じて適切に選択することが求められる。';
const String OFTEN_DETAIL =
    'よく使う、日常的な会話や特定の文脈で頻繁に使用される表現。さまざまな場面で自然に出てくることが多い。';
const String ALWAYS_DETAIL =
    'いつも使う、非常に頻繁に使用される表現で、ほぼ毎回の会話で登場する。習慣的に使用され、違和感なく使える言葉。';

// TPOの違いの定義
const String SLUNG = '- slung';
const String CASUAL = '- casual';
const String FORMAL = '- formal';
const String BUSINESS = '- business';
const String TECH = '- tech';

const String SLUNG_DETAIL =
    'くだけた表現、主に友人や家族とのカジュアルな会話に適する。口語的で自由な表現が多く、ジョークや隠喩が含まれることがある。';
const String CASUAL_DETAIL =
    'カジュアルな表現、親しい友人や同僚とのリラックスした会話に適する。砕けた言葉遣いと適度な敬意を保ちながら、自然体で話す場面で使われる。';
const String FORMAL_DETAIL =
    'フォーマルな表現、公式な場や目上の人との会話に適する。丁寧で洗練された言葉遣いが求められ、感謝や謝罪を表現する際にも使われる。';
const String BUSINESS_DETAIL =
    'ビジネス表現、ビジネスの場や職場での会話に適する。プロフェッショナルな言葉遣いで、明確かつ礼儀正しいコミュニケーションが求められる。';
const String TECH_DETAIL =
    '技術的な表現、専門的な知識が必要な場面で使用される。特定の業界や技術に関連する用語や言い回しが含まれ、正確で一貫性のあるコミュニケーションが求められる。';

// final Map<int, List<TextSpan>> columnTexts = {
//   1: [
//     buildTextSpan(NOUN, NOUN_DETAIL, false),
//     buildTextSpan(VERB, VERB_DETAIL, false),
//     buildTextSpan(AUXILIARY_VERB, AUXILIARY_VERB_DETAIL, false),
//     buildTextSpan(ADJECTIVE, ADJECTIVE_DETAIL, false),
//     buildTextSpan(ADVERB, ADVERB_DETAIL, false),
//     buildTextSpan(PRONOUN, PRONOUN_DETAIL, false),
//     buildTextSpan(PREPOSITION, PREPOSITION_DETAIL, false),
//     buildTextSpan(CONJUNCTION, CONJUNCTION_DETAIL, false),
//     buildTextSpan(ARTICLE, ARTICLE_DETAIL, false),
//     buildTextSpan(INTERJECTION, INTERJECTION_DETAIL, false),
//     buildTextSpan(PHRASE, PHRASE_DETAIL, true),
//   ],
//   2: [
//     buildTextSpan(LV1, LV1_DETAIL, false),
//     buildTextSpan(LV2, LV2_DETAIL, false),
//     buildTextSpan(LV3, LV3_DETAIL, false),
//     buildTextSpan(LV4, LV4_DETAIL, false),
//     buildTextSpan(LV5, LV5_DETAIL, false),
//     buildTextSpan(LV6, LV6_DETAIL, false),
//     buildTextSpan(LV7, LV7_DETAIL, false),
//     buildTextSpan(LV8, LV8_DETAIL, false),
//     buildTextSpan(LV9, LV9_DETAIL, false),
//     buildTextSpan(LV10, LV10_DETAIL, true),
//   ],
//   3: [
//     buildTextSpan(NEVER, NEVER_DETAIL, false),
//     buildTextSpan(RARELY, RARELY_DETAIL, false),
//     buildTextSpan(SOMETIMES, SOMETIMES_DETAIL, false),
//     buildTextSpan(OFTEN, OFTEN_DETAIL, false),
//     buildTextSpan(ALWAYS, ALWAYS_DETAIL, true),
//   ],
//   4: [
//     buildTextSpan(SLUNG, SLUNG_DETAIL, false),
//     buildTextSpan(CASUAL, CASUAL_DETAIL, false),
//     buildTextSpan(FORMAL, FORMAL_DETAIL, false),
//     buildTextSpan(BUSINESS, BUSINESS_DETAIL, false),
//     buildTextSpan(TECH, TECH_DETAIL, true)
//   ],
// };

// TextSpan buildTextSpan(String text, String detail, bool? isLast) {
//   return TextSpan(
//     children: [
//       TextSpan(
//         text: text + LINE_FEED,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//       ),
//       const TextSpan(
//         text: LINE_FEED,
//         style: TextStyle(fontSize: 7),
//       ),
//       TextSpan(
//         text: detail + LINE_FEED,
//         style: const TextStyle(fontSize: 16),
//       ),
//       if (isLast == false)
//         const TextSpan(
//           text: LINE_FEED,
//           style: TextStyle(fontSize: 22),
//         ),
//     ],
//   );
// }
