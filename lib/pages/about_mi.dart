import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMi extends StatelessWidget {
  void launchWhatsappOpen({@required number}) async {
    String url = "whatsapp://send?phone=$number";
    //String url = "https://api.whatsapp.com/send?phone=$number";
    await canLaunch(url) ? launch(url) : print("can not open whatsapp");
  }

  Future<void> _luanchWhatsapp(String url) async {
    if (await canLaunch(url)) {
      final bool openwhatsapp = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!openwhatsapp) {
        await launch(url, forceSafariVC: true);
      }
    }
  }

  openUrl() async {
    if (await canLaunch("https://bio.site/wgd5po")) {
      await launch("https://bio.site/wgd5po");
    } else
      print('can not open url');
  }

  @override
  Widget build(BuildContext context) {
    var wi = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            height: he,
            width: wi,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue[50],
                Colors.blue[100],
                Colors.blue[200],
                Colors.blue[300],
                Colors.blue[400],
                Colors.blue[500],
                Colors.blue[600],
                Colors.blue[700],
                Colors.blue[800],
                Colors.blue[900],
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: he * 0.1,
                ),
                Text(
                  "درباره برنامه و سازنده ",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: wi * 0.08,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: he * 0.1,
                ),
                SizedBox(
                  width: wi * 0.05,
                ),
                ListTile(
                  leading: Text("نام برنامه"),
                  title: Text("ذخیره پسورد تیک"),
                  trailing: Icon(Icons.app_registration),
                ),
                ListTile(
                  leading: Text("سازنده"),
                  title: Text("Hemn.1993"),
                  // trailing: Icon(Icons.app_registration),
                ),
                ListTile(
                  leading: Text("ارتباط تلفنی"),
                  title: Text("09305437893"),
                  trailing: Icon(Icons.phone_iphone_sharp),
                ),
                ListTile(
                  onTap: () {
                    openUrl();
                  },
                  leading: Text("ارتباط با سازنده"),
                  title: Text("open link"),
                  // title: Link(
                  //   uri: Uri.parse("https://bio.site/wgd5po"),
                  //   target: LinkTarget.blank,
                  //   builder: (context, follwlink) {
                  //     return ElevatedButton(
                  //       style: ButtonStyle(
                  //         animationDuration: Duration(milliseconds: 2000),
                  //       ),
                  //       onPressed: follwlink,
                  //       child: Text("مشاهده راه های ارتباطی"),
                  //     );
                  //   },
                  // ),
                  trailing: Icon(Icons.message_outlined),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
