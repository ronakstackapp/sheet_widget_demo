import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sheet_widget_demo/ApiCallingWithPagination/demo_page_api.dart';
import 'package:sheet_widget_demo/provider/provider_api.dart';
import 'package:sheet_widget_demo/provider/provider_api_view_model.dart';
import 'package:sheet_widget_demo/utils/color.dart';

class ProviderApiDemo extends StatefulWidget {
  const ProviderApiDemo({Key key}) : super(key: key);

  @override
  ProviderApiDemoState createState() => ProviderApiDemoState();
}

class ProviderApiDemoState extends State<ProviderApiDemo> {
  DemoPageApi demoPageApi = DemoPageApi();
  ProviderViewModel providerViewModel;

  @override
  Widget build(BuildContext context) {
    print("currant page-->$runtimeType");
    // ignore: unnecessary_statements
    providerViewModel ?? (providerViewModel = ProviderViewModel(this));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text("Provider demo"),
      ),
      body: providerViewModel.providerData == null || providerViewModel.providerData.length == 0
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: black,
              ),
            )
          : ChangeNotifierProvider<ProviderPageApi>(
              create: (BuildContext context) {
                return ProviderPageApi();
              },
              child: Container(
                child: ListView.builder(
                    itemCount: providerViewModel.providerData.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: themeColor, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(13),
                              child: Text(
                                " id : ${providerViewModel.providerData[index].id}",
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(13),
                              child:
                                  Text(" author : ${providerViewModel.providerData[index].author}"),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
    );
  }
}
