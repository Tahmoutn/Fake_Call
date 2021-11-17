import 'package:fake_call/providers/IntroProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SecondPage extends StatefulWidget {

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Future<void> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'': ''},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text('Privacy Policy',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600
              ),
              textAlign: TextAlign.center,),
          ),
          Divider(),
          Text('Intro',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          SizedBox(
            height: 20,
          ),
          Text(
              '    Next-studio designed these apps as ad-supported apps.\n'
              '    This service is provided by Next studio at no cost and is intended for use as is'
              'This page is used to inform visitors regarding my policies with the collection, use, '
                  'and disclosure of Personal Information if anyone decided to use my Service.\n'
              '    If you choose to use my Service, then you agree to the collection and use of '
                  'information in relation to this policy.\n'
                  '    The Personal Information that I collect is used for '
                  'providing and improving the Service.\n    '
                  'I will not use or share your information with anyone except as '
                  'described in this Privacy Policy.\n'
          '    The terms used in this Privacy Policy have the same meanings as in '
                  'our Terms and Conditions, which is accessible at '
                  'Cloud notes unless otherwise defined in this Privacy Policy.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Information Collection and Use',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    For a better experience, while using our Service, '
                'I may require you to provide us with certain personally '
                'identifiable information, including but not limited to Name, Email.\n'
                '    The information that I request will be retained on your '
                'device and is not collected by me in any way.\n'
                '    The app does use third party services that '
                'may collect information used to identify you.\n'
                '    Link to privacy policy of third party '
                'service providers used by the app.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.green.shade50)
              ),
              onPressed: () => _launchInWebViewOrVC('https://policies.google.com/privacy'),
              child: Text('Google Play Services'),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue.shade50)
            ),
              onPressed: () => _launchInWebViewOrVC('https://www.facebook.com/policies/ads/'),
              child: Text('Facebook Advertising Policies',
              style: TextStyle(
                color: Colors.blue
              ),),
          ),
          TextButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateColor.resolveWith((states) => Colors.amber.shade50)
            ),
              onPressed: () => _launchInWebViewOrVC('https://firebase.google.com/policies/analytics'),
              child: Text('Firebase Analytics',
              style: TextStyle(
                color: Colors.amber.withGreen(150)
              ),),
          ),
          Divider(),
          Text('Log Data',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    I want to inform you that whenever you use my Service, '
                'in a case of an error in the app, I collect data and '
                'information (through third party products) on your phone '
                'called Log Data.\n    This Log Data may include information '
                'such as your device Internet Protocol (“IP”) address, '
                'device name, operating system version, the configuration '
                'of the app when utilizing my Service, the time and date '
                'of your use of the Service, and other statistics.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Cookies',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    Cookies are files with a small amount of data that are '
                'commonly used as anonymous unique identifiers.\n'
                '    These are sent to your browser from the websites '
                'that you visit and are stored on your device’s internal memory.\n'
          '    This Service does not use these “cookies” explicitly. However, '
                'the app may use third party code and libraries that use '
                '“cookies” to collect information and improve their services.\n'
                '    You have the option to either accept or refuse these '
                'cookies and know when a cookie is being sent to your device.\n'
                '    If you choose to refuse our cookies, you may not be '
                'able to use some portions of this Service.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Service Providers',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    I may employ third-party companies and individuals due to the following reasons:\n'
            '- To facilitate our Service;\n'
            '- To provide the Service on our behalf;\n'
            '- To perform Service-related services; or\n'
            '- To assist us in analyzing how our Service is used.\n'
            '    I want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Security',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    I value your trust in providing us your Personal Information, '
                'thus we are striving to use commercially acceptable means '
                'of protecting it.\n    But remember that no method of transmission '
                'over the internet, or method of electronic storage is '
                '100% secure and reliable, and I cannot guarantee '
                'its absolute security.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Links to Other Sites',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    This Service may contain links to other sites.\n'
            '    If you click on a third-party link, you will '
                'be directed to that site.\n'
                ' Note that these external sites are not operated '
                'by me.\n Therefore, I strongly advise you to '
                'review the Privacy Policy of these websites.\n'
                ' I have no control over and assume no responsibility '
                'for the content, privacy policies, or practices '
                'of any third-party sites or services.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Children’s Privacy',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    These Services do not address anyone under the age of 13.\n'
                ' I do not knowingly collect personally identifiable '
                'information from children under 13.\n'
                ' In the case I discover that a child under 13 '
                'has provided me with personal information, '
                'I immediately delete this from our servers.\n'
                ' If you are a parent or guardian and you are aware '
                'that your child has provided us with personal information,'
                ' please contact me so that I will be able to do necessary actions.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Changes to This Privacy Policy',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    I may update our Privacy Policy from time to time.\n'
                ' Thus, you are advised to review this page periodically '
                'for any changes.\n I will notify you of any changes '
                'by posting the new Privacy Policy on this page.\n'
                ' These changes are effective immediately after they '
                'are posted on this page.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Text('Contact Us',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400
            ),
            textAlign: TextAlign.left,),
          Divider(),
          Text(
            '    If you have any questions or suggestions about my Privacy Policy, '
                'do not hesitate to contact me at tahmoutn@gmail.com.',
            style: TextStyle(
                fontSize: 16
            ),
          ),
          Divider(),
          Card(
            elevation: 0,
            color: Colors.green.shade50,
            child: CheckboxListTile(
                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('I agree of privacy and terms of use',
                    style: TextStyle(
                      color: Colors.green
                    ),
                  ),
                ),
                value: context.watch<IntroProvider>().checkboxValue,
                checkColor: Colors.white,
                onChanged: (v){
                  if(v){
                    print(v);
                    context.read<IntroProvider>().changeCheckboxValue(v);
                  } else context.read<IntroProvider>().changeCheckboxValue(v);
                }),
          ),
        ],
      ),
    );
  }
}
