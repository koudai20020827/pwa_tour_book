import 'package:flutter/material.dart';
import 'package:audio2/common_utils/colors.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: primaryGray,
        title: const Text("利用規約",
            style: TextStyle(
              color: Colors.white,
            )),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('第1条（適用範囲）'),
            _buildSectionContent(
              '本利用規約（以下「本規約」といいます。）は、AI英単語アプリ（以下「本アプリ」といいます。）の利用に関する条件を定めるものであり、本アプリを利用する全てのユーザーに適用されます。',
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('第2条（利用条件）'),
            _buildIndentedNumberedList([
              '本アプリは、ユーザー登録やログイン手続きを要せず、自由に利用することができます。',
              '本規約は、本アプリを初めて利用した時点で、全てのユーザーに適用されるものとします。',
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle('第3条（禁止事項）'),
            _buildSectionContent(
              'ユーザーは、本アプリの利用に際して、以下の行為を行ってはならないものとします。',
            ),
            _buildIndentedNumberedList([
              '他のユーザーまたは第三者の権利を侵害する行為',
              '本アプリの正常な運営を妨害する行為',
              '不正アクセスや不正利用、その他違法行為',
              '本アプリのコンテンツを無断で複製、改変、配布、販売する行為',
              '運営者が不適切と判断するその他の行為',
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle('第4条（コンテンツの利用）'),
            _buildIndentedNumberedList([
              'ユーザーは、本アプリで提供される全てのコンテンツを個人的な利用目的の範囲内でのみ利用できるものとします。',
              '本アプリのコンテンツを無断で複製、改変、配布、販売することは禁止されています。',
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle('第5条（知的財産権）'),
            _buildSectionContent(
              '本アプリに関連する全ての知的財産権は、運営者または正当な権利を有する第三者に帰属します。'
              '本規約に基づきユーザーに付与される権利は、コンテンツの個人的な利用に限定されます。',
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('第6条（免責事項）'),
            _buildSectionContent(
              '本アプリは、現状有姿で提供され、運営者はその正確性、完全性、信頼性について保証しません。'
              '運営者は、ユーザーが本アプリを利用することにより発生したいかなる損害に対しても責任を負いません。',
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('第7条（利用の停止・変更）'),
            _buildSectionContent(
              '運営者は、ユーザーに事前の通知なく、本アプリの一部または全部の利用を停止、変更、または終了することができるものとします。'
              '運営者は、上記の利用停止・変更・終了によりユーザーに生じた損害について、一切の責任を負いません。',
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('第8条（規約の変更）'),
            _buildIndentedNumberedList([
              '運営者は、本規約を随時変更することができるものとし、変更後の規約は、本アプリ内で表示された時点で効力を生じるものとします。',
              'ユーザーは、変更後の規約が適用されることに同意したものとみなします。',
            ]),
            const SizedBox(height: 32),
            _buildSectionTitle('第9条（準拠法および管轄）'),
            _buildSectionContent(
              '本規約は、日本法に準拠し、解釈されるものとします。'
              '本アプリに関する紛争が生じた場合、運営者の所在地を管轄する裁判所を第一審の専属管轄裁判所とします。',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionContent(String content) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 8.0),
      child: Text(
        content,
        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.8),
      ),
    );
  }

  Widget _buildIndentedNumberedList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${items.indexOf(item) + 1}. ',
                style: const TextStyle(
                    color: Colors.white, fontSize: 16, height: 1.8),
              ),
              Expanded(
                child: Text(
                  item,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 16, height: 1.8),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
