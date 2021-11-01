import 'package:flutter/material.dart';
import 'package:sms_classification/styles/constant.dart';
import 'package:sms_classification/widgets/listTentang.dart';

class TentangScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang',
        ),
      ),
      body: Card(
        color: secondaryColor,
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTentang(
                icon: Icons.bookmark,
                title: 'Judul',
                teks:
                    'Implementasi Machine Learning Pada Sistem Pendeteksi SMS Penipuan Berbasis Android',
              ),
              const SizedBox(height: 8),
              ListTentang(
                icon: Icons.person,
                title: 'Mahasiswa',
                teks: 'Arwan \n216280042',
              ),
              const SizedBox(height: 8),
              ListTentang(
                icon: Icons.supervisor_account,
                title: 'Pembimbing',
                teks: '- Muh. Zainal, ST., MT \n- Marlina, S.Kom., M.Kom',
              ),
              const SizedBox(height: 8),
              ListTentang(
                icon: Icons.supervisor_account,
                title: 'Penguji',
                teks: '- Mugaffir Yunus, ST., MT \n- Ahmad Selao, STP., M.Sc.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
